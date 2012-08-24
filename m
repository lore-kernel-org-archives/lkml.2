Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab2HXN5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:57:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48993 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759477Ab2HXN5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:57:38 -0400
Message-ID: <503786C7.50205@gmail.com>
Date: Fri, 24 Aug 2012 15:51:03 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: Re: [RFC] [PATCH] vfs: remount all file-systems R/O on emergency
 remount.
References: <1345793166-14230-1-git-send-email-dedekind1@gmail.com>  <50377FA7.50708@gmail.com> <1345815532.2848.313.camel@sauron.fi.intel.com>
In-Reply-To: <1345815532.2848.313.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/08/2012 15:38, Artem Bityutskiy ha scritto:
> On Fri, 2012-08-24 at 15:20 +0200, Marco Stornelli wrote:
>> Il 24/08/2012 09:26, Artem Bityutskiy ha scritto:
>>> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>>>
>>> Currently the emergency remount (triggered by Sysrq-u) re-mounting only
>>> those file-systems R/O, which have an associated block device (sb->s_bdev).
>>> This does not work for file-systems like UBIFS and JFFS2 which work on top
>>> of MTD devices (character devices) and always have sb->s_bdev = NULL.
>>>
>>> This also does not work for tmpfs.
>>>
>>> Most probably the intention was to avoid re-mounting R/O file-systems like
>>> procfs, sysfs, cgroup, and debugfs. However, I do not really see why not
>>> to remount them R/O as well in case of emergency.
>>>
>>> This patch removes the 'sb->s_bdev != NULL' check from
>>> 'do_emergency_remount()', so _all_ file-systems will be re-mounted R/O.
>>>
>>> Tested in Fedora - all file-systems (ext4, ubifs, procfs, sysfs, cgroup, and
>>> debugfs) become R/O on Sysrq-u with this patch.
>>>
>>> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>>
>> Does it make sense to remount r/o for example debugfs in this case?
>> Maybe if there is something wrong I want enable something to catch debug
>> info. Similar things for other pseudo-fs. Sure, the s_bdev seems a
>> strong check. We could add a new flag to know if the emergency remount
>> should be happen. It would give us the fs granularity, and maybe it
>> could be turned on/off with the mount.
>
> May be. Or may be you are in situation that you really want all
> processes top modifying anything in debugfs. This depends on the
> "emergency" you deal with. You can always re-mount debugfs back to rw by
> hands using something like:
>
> 	mount -t debufs -o remount,rw none /sys/kernel/debug
>

Obviously :) Maybe it's the sign that we want let the user decide what 
to do if the "default behavior" is not ok.

Note: has ubifs got the field s_mtd != null? Maybe to solve the specific 
problem we could just write (sb->s_bdev != NULL || sb->s_mtd != NULL).

Marco
