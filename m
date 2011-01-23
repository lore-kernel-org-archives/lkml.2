Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab1AWPLO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:11:14 -0500
Received: from mail.wdtv.com ([66.118.69.84]:54400 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1AWPLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:11:13 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Sun, 23 Jan 2011 10:11:08 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.5; i686; ; )
References: <4D3C3B1E.1080500@pardus.org.tr> <4D3C42A5.6060909@t-online.de>
In-Reply-To: <4D3C42A5.6060909@t-online.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201101231011.08513.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 23, 2011, Richard Schütz wrote:
>> Hi,
>> 
>> I'm getting a lot of bug reports about hanging boot/shutdowns on these
>> days.
>> 
>> Most of the affected hardware are ASUS laptops. The problem is that I
>> don't have access to any of those problematic laptops and the users are
>> not able at all to debug/bisect what is going on. However, I have
>> collected dmesgs of good/bad boots, acpidump, etc.
>> 
>> Here are the current status:
>> 
>> "Asus F50SV does not boot unless lapic is passed"
>> https://bugzilla.kernel.org/show_bug.cgi?id=26502
>> 
>> "Regression between 2.6.35-020635-rc1 and 2.6.35-020635 breaks acpi
>> support on Asus X71 laptop"
>> https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/689796
>> 
>> "Asus N61JQ hangs at shutdown unless lapic is passed"
>> (Not reported upstream yet, I've only downstream bug report which is
>> Turkish)
>> http://bugs.pardus.org.tr/show_bug.cgi?id=15969
>> 
>> "Asus X61S does not boot unless acpi=off is given"
>> (Not reported upstream yet, I've only downstream bug report which is
>> Turkish)
>> http://bugs.pardus.org.tr/show_bug.cgi?id=16322
>> (I've told the reporter to try with nolapic, it will probably fix the
>> issue but until confirmed acpi=off is the only solution. 2.6.36 was
>> fine)
>> 
>> I'll post more bugs in here as I've found them.
>> 
>> Thanks,
>
>Looks like these are all Intel machines. Do they use intel_idle for the
>CPU powersaving features?
>(cat /sys/devices/system/cpu/cpuidle/current_driver)
>
>If yes - does booting with intel_idle.max_cstate=0 or
>intel_idle.max_cstate=3 boot parameter help?
>
>It could be related to https://bugzilla.kernel.org/show_bug.cgi?id=21952
>somehow, which seems to be an 2.6.35 regression.

This hang on shutdown, (I have an asus big board) can it also be caused by 
not having /var as a dir on /? 

After having been burnt by / going read-only, depriving me of the failure 
log, I have always put /var on its own partition, which is unmounted early 
and then halt can't get a lockfile, so it hangs after turning off the 
swaps. I have to hit the hardware reset button from there to complete the 
reboot.

Twould be nice if there was a fix for that. ;)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Downgrade your system for only 89 dollars! Install Windows!
