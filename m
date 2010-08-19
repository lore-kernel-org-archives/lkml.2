Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab0HSA2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:28:41 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39023 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0HSA2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:28:38 -0400
Date: Wed, 18 Aug 2010 19:28:37 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: properly mark init functions
Message-ID: <20100819002836.GA8552@boomer>
References: <4C6AA995.6040008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6AA995.6040008@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Aug 17, 2010 at 05:24:05PM +0200, Jerome Marchand <jmarchan@redhat.com> wrote:
> 
> Some ecryptfs init functions are not prefixed by __init and thus not
> freed after initialization. This patch saved about 1kB in ecryptfs
> module.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---

Thanks Jerome - We could also get away with marking
ecryptfs_init_kmem_caches() and do_sysfs_registration() with __init,
right?

Tyler

>  crypto.c    |    2 +-
>  kthread.c   |    2 +-
>  messaging.c |    2 +-
>  miscdev.c   |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index a2e3b56..13ff48b 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -1793,7 +1793,7 @@ struct kmem_cache *ecryptfs_key_tfm_cache;
>  static struct list_head key_tfm_list;
>  struct mutex key_tfm_list_mutex;
> 
> -int ecryptfs_init_crypto(void)
> +int __init ecryptfs_init_crypto(void)
>  {
>  	mutex_init(&key_tfm_list_mutex);
>  	INIT_LIST_HEAD(&key_tfm_list);
> diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
> index d8c3a37..0851ab6 100644
> --- a/fs/ecryptfs/kthread.c
> +++ b/fs/ecryptfs/kthread.c
> @@ -86,7 +86,7 @@ out:
>  	return 0;
>  }
> 
> -int ecryptfs_init_kthread(void)
> +int __init ecryptfs_init_kthread(void)
>  {
>  	int rc = 0;
> 
> diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
> index bcb68c0..ab22480 100644
> --- a/fs/ecryptfs/messaging.c
> +++ b/fs/ecryptfs/messaging.c
> @@ -473,7 +473,7 @@ sleep:
>  	return rc;
>  }
> 
> -int ecryptfs_init_messaging(void)
> +int __init ecryptfs_init_messaging(void)
>  {
>  	int i;
>  	int rc = 0;
> diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
> index 3745f61..00208c3 100644
> --- a/fs/ecryptfs/miscdev.c
> +++ b/fs/ecryptfs/miscdev.c
> @@ -500,7 +500,7 @@ static struct miscdevice ecryptfs_miscdev = {
>   *
>   * Returns zero on success; non-zero otherwise
>   */
> -int ecryptfs_init_ecryptfs_miscdev(void)
> +int __init ecryptfs_init_ecryptfs_miscdev(void)
>  {
>  	int rc;
> 
