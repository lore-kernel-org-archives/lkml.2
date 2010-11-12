Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0KLRkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:40:46 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:43970 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0KLRkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:40:43 -0500
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
In-Reply-To: <24801.1289580779@redhat.com>
References: <1289404309-15955-4-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <24801.1289580779@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 12:39:52 -0500
Message-ID: <1289583592.4341.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 16:52 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

Again, thanks for the detailed review!
Willdo on all suggestions with a couple of comments/questions:

> > +#define TPM_MAX_BUF_SIZE		512
> > +#define TPM_TAG_RQU_COMMAND		193
> > +#define TPM_TAG_RQU_AUTH1_COMMAND	194
> > +#define TPM_TAG_RQU_AUTH2_COMMAND	195
> > +#define TPM_TAG_RSP_COMMAND		196
> > +#define TPM_TAG_RSP_AUTH1_COMMAND	197
> > +#define TPM_TAG_RSP_AUTH2_COMMAND	198
> > +#define TPM_NONCE_SIZE			20
> > +#define TPM_HASH_SIZE			20
> > +#define TPM_SIZE_OFFSET			2
> > +#define TPM_RETURN_OFFSET		6
> > +#define TPM_DATA_OFFSET			10
> > +#define TPM_U32_SIZE			4
> > +#define TPM_GETRANDOM_SIZE		14
> > +#define TPM_GETRANDOM_RETURN		14
> > +#define TPM_ORD_GETRANDOM		70
> > +#define TPM_RESET_SIZE			10
> > +#define TPM_ORD_RESET			90
> > +#define TPM_OSAP_SIZE			36
> > +#define TPM_ORD_OSAP			11
> > +#define TPM_OIAP_SIZE			10
> > +#define TPM_ORD_OIAP			10
> > +#define TPM_SEAL_SIZE			87
> > +#define TPM_ORD_SEAL			23
> > +#define TPM_ORD_UNSEAL			24
> > +#define TPM_UNSEAL_SIZE			104
> > +#define SEALKEYTYPE			1
> > +#define SRKKEYTYPE			4
> > +#define SRKHANDLE			0x40000000
> > +#define TPM_ANY_NUM			0xFFFF
> > +#define MAX_PCRINFO_SIZE		64
> 
> I suspect some of these should be in somewhere like linux/tpm.h rather than
> here.  They're specific to TPM access not TPM key management.

Most of them are not already defined in tpm.h, as they are never used
there, but you are right, some are generic. I'll double check these..

> > +#define TPM_DEBUG 0
> 
> The TPM_DEBUG stuff should probably be in the directory with the sources, not
> in a directory for others to include.

Maybe some confusion here - trusted_defined.h is in the sources - only
trusted-type.h is public in include/keys/.

> > +#if TPM_DEBUG
> > +static inline void dump_options(struct trusted_key_options *o)
> > +{
> > +	pr_info("trusted_key: sealing key type %d\n", o->keytype);
> > +	pr_info("trusted_key: sealing key handle %0X\n", o->keyhandle);
> > +	pr_info("trusted_key: pcrlock %d\n", o->pcrlock);
> > +	pr_info("trusted_key: pcrinfo %d\n", o->pcrinfo_len);
> > +	print_hex_dump(KERN_INFO, "pcrinfo ", DUMP_PREFIX_NONE,
> > +		       16, 1, o->pcrinfo, o->pcrinfo_len, 0);
> > +}
> > +
...
> > +
> > +static inline void store16(struct tpm_buf *buf, uint16_t value)
> > +{
> > +	*(uint16_t *) & buf->data[buf->len] = htons(value);
> > +	buf->len += sizeof(value);
> > +}
> > +
> > +static inline void store32(struct tpm_buf *buf, uint32_t value)
> > +{
> > +	*(uint32_t *) & buf->data[buf->len] = htonl(value);
> > +	buf->len += sizeof(value);
> > +}
> > +
> > +static inline void storebytes(struct tpm_buf *buf, unsigned char *in, int len)
> > +{
> > +	memcpy(buf->data + buf->len, in, len);
> > +	buf->len += len;
> > +}
> 
> Also these look like internal functions which shouldn't be in the global
> headers.

This is in trusted_defined.h, which is with sources, not in
include/keys/

thanks!
dave

