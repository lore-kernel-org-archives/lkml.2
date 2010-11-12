Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab0KLM77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 07:59:59 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:55483 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab0KLM76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 07:59:58 -0500
Subject: Re: [PATCH v1.3 3/4] keys: add new trusted key-type
From: David Safford <safford@watson.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <8100.1289512670@redhat.com>
References: <1289404309-15955-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <8100.1289512670@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 07:58:11 -0500
Message-ID: <1289566691.4341.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 21:57 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

Thanks for the helpful comments - much appreciated.
Willdo on all of them - just one question on the last comment:

> > +/*
> > + * Have the TPM seal(encrypt) the trusted key, possibly based on
> > + * Platform Configuration Registers (PCRs). AUTH1 for sealing key.
> > + */
> > +static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
> > +		    uint32_t keyhandle, unsigned char *keyauth,
> > +		    unsigned char *data, uint32_t datalen,
> > +		    unsigned char *blob, uint32_t * bloblen,
> > +		    unsigned char *blobauth,
> > +		    unsigned char *pcrinfo, uint32_t pcrinfosize)
> > +{
> > +	struct osapsess sess;
> > +	unsigned char encauth[TPM_HASH_SIZE];
> > +	unsigned char pubauth[TPM_HASH_SIZE];
> > +	unsigned char xorwork[TPM_HASH_SIZE * 2];
> > +	unsigned char xorhash[TPM_HASH_SIZE];
> > +	unsigned char nonceodd[TPM_NONCE_SIZE];
> 
> That's quite a lot of stack space, and you're calling other functions that
> also allocate chunks of stack space.

checkstack showed that the max stack usage was for tpm_seal, at 530
bytes. (The rest were 300 or less.)  I can certainly throw the hashes
and nonce (120 bytes) into a dynamically allocated struct, if you
think it is worth the extra code...

thanks
dave
