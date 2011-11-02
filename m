Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab1KBRDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:03:11 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:57973 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab1KBRDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:03:06 -0400
Subject: Re: [PATCH 1/2] trusted-key: allow overwriting the migratable flag
From: David Safford <safford@watson.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@us.ibm.com, dhowells@redhat.com,
        jmorris@namei.org
Date: Wed, 02 Nov 2011 12:58:56 -0400
In-Reply-To: <1320237682-3857-1-git-send-email-roberto.sassu@polito.it>
References: <1320237682-3857-1-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1320253136.3225.13.camel@localhost>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 13:41 +0100, Roberto Sassu wrote:
> The migratable should be modifiable during the key update() method. This
> allows for example to update a migratable trusted key, wrapped by a TPM
> key, to a a non-migratable one sealed under the SRK with a PCR set.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>

I can see a use case for updating a migratable key to a non-migratable
one - such as keeping a migratable master on a flash drive, and keeping
only the non-migratable copy on-line. I certainly don't want the 
ability to change a non-migratable to migratable, as that would defeat
the entire purpose of non-migratable.

I don't think this patch actually does either, though. 

> ---
>  security/keys/trusted.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/security/keys/trusted.c b/security/keys/trusted.c
> index 0c33e2e..8777015 100644
> --- a/security/keys/trusted.c
> +++ b/security/keys/trusted.c
> @@ -1036,7 +1036,6 @@ static int trusted_update(struct key *key, const void *data, size_t datalen)
>  		goto out;
>  	}
>  	/* copy old key values, and reseal with new pcrs */
> -	new_p->migratable = p->migratable;

Taking out this line appears only to remove a redundant assignment.
We can only get here if the old key is already migratable, and the
earlier trusted_payload_alloc() initializes the new copy to
migratable by default. I don't see how the flag can be changed
with this patch. Perhaps I'm missing something or this was just 
the start, and there is more to come?

dave

>  	new_p->key_len = p->key_len;
>  	memcpy(new_p->key, p->key, p->key_len);
>  	dump_payload(p);

