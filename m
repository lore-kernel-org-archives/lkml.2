Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab0JHTKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:10:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40025 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab0JHTKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:10:39 -0400
Date: Fri, 8 Oct 2010 14:10:45 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, jmorris@namei.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] ecryptfs: checking return code of
 ecryptfs_find_auth_tok_for_sig()
Message-ID: <20101008191045.GC15669@boomer>
References: <201010061831.15661.roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010061831.15661.roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Oct 06, 2010 at 06:31:15PM +0200, Roberto Sassu <roberto.sassu@polito.it> wrote:
> This patch replaces the check of the 'matching_auth_tok' pointer with
> the exit status of ecryptfs_find_auth_tok_for_sig().
> This avoids to use authentication tokens obtained through the function 
> ecryptfs_keyring_auth_tok_for_sig which are not valid.
> 
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---

Nice catch - applied to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

Thanks!

>  fs/ecryptfs/keystore.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 77580db..643d011 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -1819,11 +1819,11 @@ find_next_matching_auth_tok:
>  			rc = -EINVAL;
>  			goto out_wipe_list;
>  		}
> -		ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
> +		rc = ecryptfs_find_auth_tok_for_sig(&auth_tok_key,
>  					       &matching_auth_tok,
>  					       crypt_stat->mount_crypt_stat,
>  					       candidate_auth_tok_sig);
> -		if (matching_auth_tok) {
> +		if (!rc) {
>  			found_auth_tok = 1;
>  			goto found_matching_auth_tok;
>  		}
> -- 
> 1.7.2.3


