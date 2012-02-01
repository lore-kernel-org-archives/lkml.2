Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2BAS3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:29:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37945 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2BAS3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:29:21 -0500
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: sysfs regression: wrong link counts
Date: Wed, 1 Feb 2012 19:29:15 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <4F27120A.4040106@suse.cz>
In-Reply-To: <4F27120A.4040106@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202011929.15349.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 30 stycznia 2012 o 22:56:26 Jiri Slaby wrote:
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
> 
> ad 2) look at what it does:
> /* returns !0 if sysfs filesystem was found, 0 otherwise */
> int sensors_init_sysfs(void)
> {
>         struct stat statbuf;
> 
>         snprintf(sensors_sysfs_mount, NAME_MAX, "%s", "/sys");
>         if (stat(sensors_sysfs_mount, &statbuf) < 0
> 
>          || statbuf.st_nlink <= 2)      /* Empty directory */
> 
>                 return 0;
> 
>         return 1;
> }
> 
> 
> So this looks like it became a part of ABI we cannot break...
> 
> A revert of this commit on the top of today's -next fixes the problem.
> 
> thanks,

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=42712
for your bug report, please add your address to the CC list in there, thanks!
-- 
Maciej Rutecki
http://www.mrutecki.pl
