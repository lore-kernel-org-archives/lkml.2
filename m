Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab0FUKDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:03:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab0FUKDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:03:12 -0400
Date: Mon, 21 Jun 2010 12:03:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Julia Lawall <julia@diku.dk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/hid: Eliminate a double lock
In-Reply-To: <Pine.LNX.4.64.1006201324170.4366@ask.diku.dk>
Message-ID: <alpine.LNX.2.00.1006211202550.13809@pobox.suse.cz>
References: <Pine.LNX.4.64.1006201324170.4366@ask.diku.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The path around the loop ends with the lock held, so the call to mutex_lock
> is moved before the beginning of the loop.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
[ ... ]
> diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
> index c940267..850d02a 100644
> --- a/drivers/hid/hid-debug.c
> +++ b/drivers/hid/hid-debug.c
> @@ -949,8 +949,8 @@ static ssize_t hid_debug_events_read(struct file *file, char __user *buffer,
>  	int ret = 0, len;
>  	DECLARE_WAITQUEUE(wait, current);
>  
> +	mutex_lock(&list->read_mutex);
>  	while (ret == 0) {
> -		mutex_lock(&list->read_mutex);
>  		if (list->head == list->tail) {
>  			add_wait_queue(&list->hdev->debug_wait, &wait);
>  			set_current_state(TASK_INTERRUPTIBLE);

Applied, thanks Julia.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
