Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2A3WHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:07:21 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35513 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633Ab2A3WHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:07:16 -0500
X-Sasl-enc: EZG1SqzaqCrD9Jjk9I43qJIa3GSJQDII17Q1UB6KsH+n 1327961235
Date: Mon, 30 Jan 2012 14:06:11 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Subject: Re: sysfs regression: wrong link counts
Message-ID: <20120130220611.GA26655@kroah.com>
References: <4F27120A.4040106@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F27120A.4040106@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 10:56:26PM +0100, Jiri Slaby wrote:
> Hi,
> 
> I cannot boot properly with this commit:
> commit 524b6c5b39b931311dfe5a2f5abae2f5c9731676
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Sun Dec 18 20:09:31 2011 -0800
> 
>     sysfs: Kill nlink counting.
> 
> 
> 1) network systemd rule doesn't start network
> 2) sensors complain:
>    sensors_init: Kernel interface error

Odd.

What in systemd is causing a reliance on this?

> ad 2) look at what it does:
> /* returns !0 if sysfs filesystem was found, 0 otherwise */
> int sensors_init_sysfs(void)
> {
>         struct stat statbuf;
> 
>         snprintf(sensors_sysfs_mount, NAME_MAX, "%s", "/sys");
>         if (stat(sensors_sysfs_mount, &statbuf) < 0
>          || statbuf.st_nlink <= 2)      /* Empty directory */
>                 return 0;
> 
>         return 1;
> }

Ah, a hack to see if the directory is empty.

Isn't there some other "proper" way of doing this in userspace, or is
this really the correct way?

> So this looks like it became a part of ABI we cannot break...
> 
> A revert of this commit on the top of today's -next fixes the problem.

Ick.

Eric, care to fix this up, or do you want me to revert it?

thanks,

greg k-h
