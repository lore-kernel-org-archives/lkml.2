Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0D1U6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:58:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53422 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab0D1U6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:58:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend blockers from user-space
Date: Wed, 28 Apr 2010 22:58:51 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Avi Kivity <avi@redhat.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Magnus Damm <damm@igel.co.jp>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
References: <1272429119-12103-1-git-send-email-arve@android.com> <1272429119-12103-2-git-send-email-arve@android.com> <1272429119-12103-3-git-send-email-arve@android.com>
In-Reply-To: <1272429119-12103-3-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004282258.51354.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010, Arve Hjønnevåg wrote:
> Add a misc device, "suspend_blocker", that allows user-space processes
> to block auto suspend. The device has ioctls to create a suspend_blocker,
> and to block and unblock suspend. To delete the suspend_blocker, close
> the device.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
...
> +
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +#include <linux/slab.h>
> +#include <linux/suspend_blocker.h>
> +#include <linux/suspend_block_dev.h>
> +
> +enum {
> +	DEBUG_FAILURE	= BIT(0),
> +};
> +static int debug_mask = DEBUG_FAILURE;

What's the exact purpose of this?

> +module_param_named(debug_mask, debug_mask, int, S_IRUGO | S_IWUSR | S_IWGRP);
> +
> +static DEFINE_MUTEX(ioctl_lock);
> +
> +struct user_suspend_blocker {
> +	struct suspend_blocker	blocker;
> +	char			name[0];
> +};

Why is this not in a header?

Rafael
