Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab1CRQCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:02:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51152 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab1CRQCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:02:17 -0400
Date: Fri, 18 Mar 2011 11:02:05 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: Re: [PATCH 1/5] eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix
Message-ID: <20110318160205.GD22193@boyd.l.tihix.com>
References: <1300362538-11502-1-git-send-email-roberto.sassu@polito.it>
 <1300362538-11502-2-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300362538-11502-2-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Mar 17, 2011 at 12:48:50PM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> The pointer '(*auth_tok_key)' is set to NULL in case request_key() fails,
> in order to prevent its use by functions calling
> ecryptfs_keyring_auth_tok_for_sig().

Thanks Roberto - I'm going to go ahead and merge this one into my #next
tree. Feel free to drop it from this patch set when you resend.

Tyler

> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> ---
>  fs/ecryptfs/keystore.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index c1436cf..4feb78c 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -1563,6 +1563,7 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
>  		printk(KERN_ERR "Could not find key with description: [%s]\n",
>  		       sig);
>  		rc = process_request_key_err(PTR_ERR(*auth_tok_key));
> +		(*auth_tok_key) = NULL;
>  		goto out;
>  	}
>  	(*auth_tok) = ecryptfs_get_key_payload_data(*auth_tok_key);
> -- 
> 1.7.4
> 


