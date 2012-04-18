Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2DRWQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:16:53 -0400
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:57911 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2DRWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:16:52 -0400
X-Greylist: delayed 1980 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2012 18:16:51 EDT
Message-ID: <4F8F3C74.7040000@genband.com>
Date: Wed, 18 Apr 2012 16:13:08 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org
Subject: Re: "udevadm info --attribute-walk --path=/block/sda" doesn't show
 parents
References: <4F8F3563.9020701@genband.com>
In-Reply-To: <4F8F3563.9020701@genband.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2012 22:13:09.0286 (UTC) FILETIME=[6FECEC60:01CD1DB0]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18848.002
X-TM-AS-Result: No--20.489900-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 03:42 PM, Chris Friesen wrote:
> 
> I have a 2.6.34.10-based kernel with udev-161 (also tested with udevadm from udev-173).
> 
> When I run "udevadm info --attribute-walk --path=/block/sda" it just shows the device
> itself, and doesn't walk the whole chain showing the parents.
> 
> Is there anything I can do, or am I caught with a kernel that isn't properly supported?
> I'm not subscribed to the hotplug list, so cc'ing me would be appreciated.
> 
> 
> I don't know what's causing the problem, but I find it suspicious that /sys/block/sda
> is a directory rather than a symlink like it is on my 2.6.35.14 laptop.  I'm poking
> around in the udevadm code now.

Looking at the udevadm code led me to the following:

On the problematic 2.6.34 machine:

root@typhoon-base-unit0:/root> ls -l /sys/dev/block/
<snip>
lrwxrwxrwx 1 root root 0 Apr 18 14:34 8:0 -> ../../block/sda



On my 2.6.35 machine:

[cfriesen@blah udev-173]$ ls -l /sys/dev/block/
<snip>
lrwxrwxrwx. 1 root root 0 Apr 18 15:54 8:0 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda



So where do I go from here?  Is there a simple kernel change to make my 2.6.34
kernel behave more like the more recent one?  Would an older version of udev be
able to parse my 2.6.34 /sys directory properly, or do I need to figure out a
way to parse /sys manually?

Thanks,
Chris







-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
