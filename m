Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1KVXzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 18:55:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1KVXzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 18:55:09 -0500
Date: Tue, 22 Nov 2011 15:55:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: yinghai@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/memblock.c: return -ENOMEM instead of -ENXIO on
 failure of debugfs_create_dir in memblock_init_debugfs
Message-Id: <20111122155507.af6c10e9.akpm@linux-foundation.org>
In-Reply-To: <4EB9DEF6.4080905@gmail.com>
References: <4EB9DEF6.4080905@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Nov 2011 10:01:26 +0800
Wang Sheng-Hui <shhuiw@gmail.com> wrote:

> On the failure of debugfs_create_dir, we should return -ENOMEM
> instead of -ENXIO.
> 
> The patch is against 3.1.
> 
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  mm/memblock.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index ccbf973..4d4d5ee 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -852,7 +852,7 @@ static int __init memblock_init_debugfs(void)
>  {
>  	struct dentry *root = debugfs_create_dir("memblock", NULL);
>  	if (!root)
> -		return -ENXIO;
> +		return -ENOMEM;
>  	debugfs_create_file("memory", S_IRUGO, root, &memblock.memory, &memblock_debug_fops);
>  	debugfs_create_file("reserved", S_IRUGO, root, &memblock.reserved, &memblock_debug_fops);

Well, we don't know what we should return because
debugfs_create_file() is misdesigned - it should return an ERR_PTR.

