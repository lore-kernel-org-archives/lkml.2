Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab1E3AR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 20:17:56 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:59009 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1E3ARz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 20:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:organization:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=It6UUwAmgwMuPQ3Cp+Aya5DufYKy6sPh54PE4uYJLaZW8OTS+hCZHcNnUJP1l3WGrj
         WQlHlNypnKz3jKmGZB0ZFxDwWXX6321NDqQZa1T1C2AvWZCk4E31XaJbL+EyLAsQY/jo
         fVUZuSPedlU44ip8GioWb0cIU/t2HDnpLg7sI=
From: Grant Coady <gcoady.lk@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: No /proc/diskstats accounting for loopN or md...p. disks??
Date: Mon, 30 May 2011 10:17:50 +1000
Organization: scattered
Message-ID: <hdo5u6d3rqfo7v349262i3854gkde4re10@4ax.com>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I built a RAID box, 6 x 1TB SATA drives, RAID 6, RAID10, runs well, but 
I notice that /proc/diskstats is not accumulating numbers for loop[0-7] 
devices, nor does it grab I/O numbers for partitioned mdadm RAIDs.

For that second, I partition the drives, and several RAIDs using different 
partitions are fine, but if I make a RAID6, then partition that device, 
then the eg. md125p1 device will not get stats collected, they all go to 
the parent device.  My 'cure' for this one is 'don't do that'.

Loop devices simply show all zeroes on /proc/diskstats.  No cure?

So what's the spell to get full /proc/diskstats accounting?  I looked in 
/sys/... and the same dev gets all zeroes in there too, so it looks as 
if the numbers are not simply getting calculated.

I'm running 2.6.38.7 on Slackware64-13.1 but this happens on earlier 
version kernel.  Be upgrading to Slackware64-13.37 soon, but I doubt 
it's user space...

Happy to do directed testing for you.  Also if you tell me it doesn't 
work like that, that's okay too, but then loopX should disappear from 
/proc/diskstats, no?  

Thanks heaps for info, ideas,
Grant.
