Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab1G2RJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:09:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38579 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1G2RJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:09:41 -0400
Date: Fri, 29 Jul 2011 12:09:32 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        hilld@binarystorm.net
Subject: Re: [PATCH] eCryptfs: fix compile error
Message-ID: <20110729170932.GC29604@boyd.l.tihix.com>
References: <1311958266-3724-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311958266-3724-1-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri Jul 29, 2011 at 06:51:04PM +0200, Roberto Sassu <roberto.sassu@polito.it> wrote:
> This patch fixes the compile error reported at the address:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=40292
> 
> The problem arises when compiling eCryptfs as built-in and the 'encrypted'
> key type as a module. The patch enables the 'encrypted' key type support
> for eCryptfs only when both components are compiled as built-in, both as
> modules or eCryptfs as a module and the 'encrypted' key type as built-in.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Reported-by: David Hill <hilld@binarystorm.net>
> ---
>  fs/ecryptfs/ecryptfs_kernel.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index b36c557..a2da660 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -79,7 +79,9 @@ struct ecryptfs_page_crypt_context {
>  	} param;
>  };
> 
> -#if defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)
> +#if (defined(CONFIG_ECRYPT_FS) && defined(CONFIG_ENCRYPTED_KEYS)) || \
> +	(defined(CONFIG_ECRYPT_FS_MODULE) && \
> +	(defined(CONFIG_ENCRYPTED_KEYS) || defined(CONFIG_ENCRYPTED_KEYS_MODULE)))

Thanks for the patch, Roberto.

Shouldn't this be handled in the Kconfig? It seems like it would be
better to force the encrypted key type to be built-in if eCryptfs is
configured to be built-in.

With this patch, a user could have CONFIG_ENCRYPTED_KEYS=m and
CONFIG_ECRYPT_FS=y, but still hit potentially confusing error conditions
when trying to use encrypted key support with eCryptfs.

Tyler

>  static inline struct ecryptfs_auth_tok *
>  ecryptfs_get_encrypted_key_payload_data(struct key *key)
>  {
> -- 
> 1.7.6
> 


