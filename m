Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0LGWsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:48:47 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39615 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199Ab0LGWsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:48:46 -0500
Subject: Re: [PATCH v1.5 5/5] keys: add new key-type encrypted
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>
In-Reply-To: <4182.1291383725@redhat.com>
References: <1290556535.2604.16.camel@localhost.localdomain>
	 <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <4182.1291383725@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 17:48:42 -0500
Message-ID: <1291762122.2680.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-03 at 13:42 +0000, David Howells wrote: 
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > +#define KEY_TRUSTED_PREFIX "trusted:"
> > +#define KEY_TRUSTED_PREFIX_LEN (sizeof (KEY_TRUSTED_PREFIX) - 1)
> > +#define KEY_USER_PREFIX "user:"
> > +#define KEY_USER_PREFIX_LEN (sizeof (KEY_USER_PREFIX) - 1)
> 
> I'd recommend using static const char arrays.

Ok

> > +static int datablob_parse(char *datablob, char **master_desc,
> > ...
> > +		*hex_encoded_data = *hex_encoded_iv + (2 * ivsize) + 2;
> 
> Do you need to validate the length of the string here?

definitely. thanks!

> > +static struct key *request_trusted_key(const char *trusted_desc,
> > +				       u8 **master_key,
> > +				       unsigned int *master_keylen)
> 
> You need to annotate the function with an __acquires() to indicate that it
> returns with a lock held for Sparse checking.  I think you should be able to
> do:
> 
> 	__acquires(tkey->sem)

hm, only after addding '__acquires' are there Sparse errors.

> on the line before the '{'.
> 
> > +static struct key *request_user_key(const char *master_desc, u8 **master_key,
> > +				    unsigned int *master_keylen)
> 
> Ditto.
> 
> > +static struct sdesc *init_sdesc(struct crypto_shash *alg)
> > +{
> > +	struct sdesc *sdesc;
> > +	int size;
> > +
> > +	size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
> > +	sdesc = kmalloc(size, GFP_KERNEL);
> 
> I think I'd call it alloc_sdesc() rather than init_sdesc().

Ok

> > +static int calc_hmac(u8 *digest, const u8 *key, const unsigned int keylen,
> > +		     const u8 *buf, const unsigned int buflen)
> 
> size_t not 'const unsigned int' please.  There are multiple of these within
> the patch.

Have reverted adding the unnecessary 'const' and converted some
additional 'unsigned int' to 'size_t', but there are still some
remaining; those used as crypto options.

> > +	sg_set_buf(&sg_out[0], epayload->decrypted_data,
> > +		   (unsigned int)epayload->decrypted_datalen);
> 
> Superfluous cast.
> 
> David

thanks!

Mimi 

