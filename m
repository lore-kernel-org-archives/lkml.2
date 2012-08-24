Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab2HXN1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:27:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64774 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2HXN1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:27:14 -0400
Message-ID: <50377FA7.50708@gmail.com>
Date: Fri, 24 Aug 2012 15:20:39 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: Re: [RFC] [PATCH] vfs: remount all file-systems R/O on emergency
 remount.
References: <1345793166-14230-1-git-send-email-dedekind1@gmail.com>
In-Reply-To: <1345793166-14230-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/08/2012 09:26, Artem Bityutskiy ha scritto:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>
> Currently the emergency remount (triggered by Sysrq-u) re-mounting only
> those file-systems R/O, which have an associated block device (sb->s_bdev).
> This does not work for file-systems like UBIFS and JFFS2 which work on top
> of MTD devices (character devices) and always have sb->s_bdev = NULL.
>
> This also does not work for tmpfs.
>
> Most probably the intention was to avoid re-mounting R/O file-systems like
> procfs, sysfs, cgroup, and debugfs. However, I do not really see why not
> to remount them R/O as well in case of emergency.
>
> This patch removes the 'sb->s_bdev != NULL' check from
> 'do_emergency_remount()', so _all_ file-systems will be re-mounted R/O.
>
> Tested in Fedora - all file-systems (ext4, ubifs, procfs, sysfs, cgroup, and
> debugfs) become R/O on Sysrq-u with this patch.
>
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Does it make sense to remount r/o for example debugfs in this case? 
Maybe if there is something wrong I want enable something to catch debug 
info. Similar things for other pseudo-fs. Sure, the s_bdev seems a 
strong check. We could add a new flag to know if the emergency remount 
should be happen. It would give us the fs granularity, and maybe it 
could be turned on/off with the mount.

Marco
