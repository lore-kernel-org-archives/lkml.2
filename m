Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1EYUbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:31:50 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:15327 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab1EYUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:31:47 -0400
Message-ID: <4DDD6729.7070201@tilera.com>
Date: Wed, 25 May 2011 16:31:37 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs
 cpu attribute
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <201105202159.50780.arnd@arndb.de> <4DDD55ED.2080607@tilera.com> <201105252220.23948.arnd@arndb.de>
In-Reply-To: <201105252220.23948.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2011 4:20 PM, Arnd Bergmann wrote:
> On Wednesday 25 May 2011 21:18:05 Chris Metcalf wrote:
>> The contents of the hardwall ID file are then just a cpulist of the cpus
>> covered by the hardwall, rather than introducing a new convention (as
>> quoted above, e.g. "2x2 1,1").  Individual tasks that are in the hardwall
>> can be found by reading the "hardwall" files, and we can learn where they
>> are bound in the hardwall by reading the "stat" file as is normal for
>> learning process affinity.
> Be careful with listing PID values in the hardwall files, as the PIDs
> may not be unique or visible if you combine this with PID name spaces.
> I guess the right solution would be to only list the tasks that are
> present in the name space of the thread reading the file.

Sorry not to be clearer -- I am no longer listing any PID values in the
hardwall files, for that exact reason.  You have to look at
/proc/*/hardwall (or /proc/*/tasks/*/hardwall) to find the files that are
in a particular hardwall.  This pattern is not one that's normally directly
useful, though, so I'm happy leaving it to userspace if it's desired.

>>> When you do a /sys/hypervisor/ interface, put everything into a subdirectory
>>> under /sys/hypervisor with the name of your hypervisor, to avoid naming
>>> conflicts, e.g.
>>>
>>> /sys/hypervisor/tilera-hv/board/board_serial
> I just checked for other users. The only one I could find was
> drivers/xen/sys-hypervisor.c, and it also doesn't use a subdirectory to
> identify that hypervisor. It's probably more consistent if you also don't
> do it then.
>
> You can create a directory with multiple files using sysfs_create_group()
> as the xen code does, but not nested directories.

I'll look into sysfs_create_group(), and then send a revised patch with all
the /proc and /sys changes.  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


