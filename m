Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab0JSQNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:13:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab0JSQM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:58 -0400
Date: Tue, 19 Oct 2010 12:13:19 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] cifs: cancel_delayed_work() +
 flush_scheduled_work() -> cancel_delayed_work_sync()
Message-ID: <20101019121319.16f06b76@corrin.poochiereds.net>
In-Reply-To: <4CBDBF8A.8010106@kernel.org>
References: <4CBDBF8A.8010106@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 17:55:54 +0200
Tejun Heo <tj@kernel.org> wrote:

> flush_scheduled_work() is going away.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  fs/cifs/cifs_dfs_ref.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: work/fs/cifs/cifs_dfs_ref.c
> ===================================================================
> --- work.orig/fs/cifs/cifs_dfs_ref.c
> +++ work/fs/cifs/cifs_dfs_ref.c
> @@ -44,8 +44,7 @@ static void cifs_dfs_expire_automounts(s
>  void cifs_dfs_release_automount_timer(void)
>  {
>  	BUG_ON(!list_empty(&cifs_dfs_automount_list));
> -	cancel_delayed_work(&cifs_dfs_automount_task);
> -	flush_scheduled_work();
> +	cancel_delayed_work_sync(&cifs_dfs_automount_task);
>  }
> 
>  /**

Looks like a better way to do this anyhow.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
