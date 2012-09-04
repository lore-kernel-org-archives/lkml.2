Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab2IDXS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:18:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab2IDXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:18:57 -0400
Date: Tue, 4 Sep 2012 16:18:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Use BUG_ON instead of BUG
Message-Id: <20120904161855.f34e365e.akpm@linux-foundation.org>
In-Reply-To: <1346643025-2769-1-git-send-email-prasadjoshi.linux@gmail.com>
References: <1346643025-2769-1-git-send-email-prasadjoshi.linux@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Sep 2012 09:00:25 +0530
Prasad Joshi <prasadjoshi.linux@gmail.com> wrote:

> The use of if (!head) BUG(); can be replaced with single line
> BUG_ON(!head).
> 
> Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
> ---
>  fs/proc/proc_sysctl.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index dfafeb2..63bdfa0 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -266,8 +266,7 @@ void sysctl_head_put(struct ctl_table_header *head)
>  
>  static struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *head)
>  {
> -	if (!head)
> -		BUG();
> +	BUG_ON(!head);
>  	spin_lock(&sysctl_lock);
>  	if (!use_table(head))
>  		head = ERR_PTR(-ENOENT);

We could just remove the check altogether.  The resulting NULL pointer
deref oops in use_table() will give us the same info as that BUG().

