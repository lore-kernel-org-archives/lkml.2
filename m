Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1HHQhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:37:08 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:50359 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753201Ab1HHQhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:37:07 -0400
Subject: Re: [PATCH] nbd: some trivial improvements
From: Joe Perches <joe@perches.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Clements <Paul.Clements@steeleye.com>,
        Jiri Kosina <trivial@kernel.org>
In-Reply-To: <1312794004-22047-1-git-send-email-amwang@redhat.com>
References: <1312794004-22047-1-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 09:37:05 -0700
Message-ID: <1312821425.1643.11.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 17:00 +0800, Amerigo Wang wrote:
> This patch 1) uses task_pid_nr(current) to get the pid of current process,
>  2) replaces sysfs_create_file() with device_create_file(), 3) lower
> the loglevel of an error message.

Just trivia:

> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
[]
> @@ -405,10 +405,10 @@ static int nbd_do_it(struct nbd_device *lo)
>  
>  	BUG_ON(lo->magic != LO_MAGIC);
>  
> -	lo->pid = current->pid;
> -	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
> +	lo->pid = task_pid_nr(current);
> +	ret = device_create_file(disk_to_dev(lo->disk), &pid_attr);
>  	if (ret) {
> -		printk(KERN_ERR "nbd: sysfs_create_file failed!");
> +		printk(KERN_ERR "nbd: device_create_file failed!");

Missing "\n".

