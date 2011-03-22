Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab1CVVcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 17:32:32 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51333 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab1CVVc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 17:32:29 -0400
Date: Tue, 22 Mar 2011 16:32:11 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, dhowells@redhat.com, jmorris@namei.org,
        linux-fsdevel@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, ecryptfs-devel@lists.launchpad.net
Subject: Re: [PATCH v2 0/5] eCryptfs key locking patches
Message-ID: <20110322213211.GB12197@boyd.l.tihix.com>
References: <1300719658-3184-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300719658-3184-1-git-send-email-roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Mar 21, 2011 at 04:00:50PM +0100, Roberto Sassu <roberto.sassu@polito.it> wrote:
> This patch set modifies the eCryptfs code in order to lock requested keys
> while authentication tokens are used to encrypt or decrypt files.
> 
> Changelog:
>   - removed patch "eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix"
> 	(already applied to the eCryptfs git repository at git.kernel.org);
>   - added new patch "eCryptfs: removed num_global_auth_toks from 
> 	ecryptfs_mount_crypt_stat";
>   - patch 3/5: avoid invalidating a global authentication token only if
> 	key_validate() returns the error -EKEYEXPIRED;
>   - patch 3/5: added new function
> 	process_find_global_auth_tok_for_sig_err() to handle errors
> 	returned by ecryptfs_find_global_auth_tok_for_sig();
>   - patch 3/5: return an error in the function
> 	ecryptfs_generate_key_packet_set() if at least one global
> 	authentication token cannot be retrieved.

Thanks Roberto - This revision looks good to me. I'll keep the patch set
in my tree for another day or two, to see if anyone else has comments,
and then set up a pull request to try to get it into the rc1 release.

Tyler

> 
> Roberto Sassu
> 
> 
> Roberto Sassu (5):
>   eCryptfs: removed num_global_auth_toks from ecryptfs_mount_crypt_stat
>   eCryptfs: modified size of keysig in the ecryptfs_key_sig structure
>   eCryptfs: verify authentication tokens before their use
>   eCryptfs: move ecryptfs_find_auth_tok_for_sig() call before
>     mutex_lock
>   eCryptfs: write lock requested keys
> 
>  fs/ecryptfs/crypto.c          |    1 -
>  fs/ecryptfs/ecryptfs_kernel.h |    4 +-
>  fs/ecryptfs/keystore.c        |  280 ++++++++++++++++++++++++++---------------
>  fs/ecryptfs/main.c            |    8 +-
>  4 files changed, 185 insertions(+), 108 deletions(-)
> 
> -- 
> 1.7.4
> 


