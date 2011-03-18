Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab1CRPwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:52:19 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54259 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab1CRPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:52:16 -0400
Date: Fri, 18 Mar 2011 10:52:10 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: Re: [PATCH 2/5] eCryptfs: modified size of keysig in the
 ecryptfs_key_sig structure
Message-ID: <20110318155209.GC22193@boyd.l.tihix.com>
References: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
 <1300362538-11502-3-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300362538-11502-3-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Mar 17, 2011 at 12:48:51PM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> The size of the 'keysig' array is incremented of one byte in order to make
> room for the NULL character.

Hello Roberto - I'm assuming that this change is because you want to
print the keysig in patch 3/5. I don't see where we are currently trying
to print the keysig, so I'll wait until you resubmit this patch set to
merge this one.

Along with what a patch does, please try to explain why it is useful in
the commit message.

Tyler

> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  fs/ecryptfs/ecryptfs_kernel.h |    2 +-
>  fs/ecryptfs/keystore.c        |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index e007534..8282031 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -233,7 +233,7 @@ ecryptfs_get_key_payload_data(struct key *key)
> 
>  struct ecryptfs_key_sig {
>  	struct list_head crypt_stat_list;
> -	char keysig[ECRYPTFS_SIG_SIZE_HEX];
> +	char keysig[ECRYPTFS_SIG_SIZE_HEX + 1];
>  };
> 
>  struct ecryptfs_filename {
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 4feb78c..36b68a6 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -2425,6 +2425,7 @@ int ecryptfs_add_keysig(struct ecryptfs_crypt_stat *crypt_stat, char *sig)
>  		return -ENOMEM;
>  	}
>  	memcpy(new_key_sig->keysig, sig, ECRYPTFS_SIG_SIZE_HEX);
> +	new_key_sig->keysig[ECRYPTFS_SIG_SIZE_HEX] = '\0';
>  	/* Caller must hold keysig_list_mutex */
>  	list_add(&new_key_sig->crypt_stat_list, &crypt_stat->keysig_list);
> 
> -- 
> 1.7.4
> 


