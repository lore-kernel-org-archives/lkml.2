Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1DOSFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:05:55 -0400
Received: from mail.candelatech.com ([208.74.158.172]:54977 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab1DOSFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:05:54 -0400
Message-ID: <4DA888D6.40000@candelatech.com>
Date: Fri, 15 Apr 2011 11:05:10 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: WARNING at libata-core.c:5015 in 2.6.39-rc3-wl+, then lockup.
 (bisected)
References: <4DA5CF81.4070908@candelatech.com> <4DA5D5D8.8070301@candelatech.com> <4DA5F3BA.3060404@candelatech.com> <4DA87A72.50809@candelatech.com> <4DA88707.4060704@garzik.org>
In-Reply-To: <4DA88707.4060704@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 10:57 AM, Jeff Garzik wrote:
> On 04/15/2011 01:03 PM, Ben Greear wrote:
>> Ok, it took a while, but I think I have this thing somewhat bisected.
>>
>> Starting at commit 4cc4d24efce4672f9b0e7fa27963770ae602998f, I see
>> hard-drive
>> issues. Commits right before this (in git bisect) crash in the
>> networking code
>> quite often, but the hard-drive logic seems to work at least.
>>
>> In later builds (ie, -rc3), the crashes and warnings are different, but
>> they have something to do with the file system. It's difficult to bisect
>> it any better because of all the instability...
>>
>>
>> Here are some console logs from a
>> 4cc4d24efce4672f9b0e7fa27963770ae602998f boot:
>
> (linux-ide added to CC)
>
> hmmm... that's a merge commit. Any chance you could mark an individual
> commit bad, to narrow things down a bit more? Run "git help bisect" and
> check out helpful sections "Avoiding testing a commit" and "Bisect skip".

What do I want to skip or avoid testing though?  Does bisect not know how
to deal with merges?

Here is the log, in case that helps:

4cc4d24efce4672f9b0e7fa27963770ae602998f is the first bad commit
[greearb@build-32 linux-2.6]$ git bisect log
git bisect start
# bad: [85f2e689a5c8fb6ed8fdbee00109e7f6e5fefcb6] Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86
git bisect bad 85f2e689a5c8fb6ed8fdbee00109e7f6e5fefcb6
# good: [521cb40b0c44418a4fd36dc633f575813d59a43d] Linux 2.6.38
git bisect good 521cb40b0c44418a4fd36dc633f575813d59a43d
# skip: [ec0afc9311adcfb10b90e547c23250f63939f990] Merge branch 'kvm-updates/2.6.39' of git://git.kernel.org/pub/scm/virt/kvm/kvm
git bisect skip ec0afc9311adcfb10b90e547c23250f63939f990
# good: [a99eff39c0549fe68fed150d39ec0c750e5ce1f1] powerpc: Document the Open PIC device tree binding
git bisect good a99eff39c0549fe68fed150d39ec0c750e5ce1f1
# bad: [17e75d82518ac3146966b64adc109344fcc80f8a] ARM: mach-shmobile: convert boards to use linux/mmc/sh_mobile_sdhi.h
git bisect bad 17e75d82518ac3146966b64adc109344fcc80f8a
# bad: [4cc4d24efce4672f9b0e7fa27963770ae602998f] Merge git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6
git bisect bad 4cc4d24efce4672f9b0e7fa27963770ae602998f
# good: [943fc810bdc9c0fce5cc66bdb65b42d699241aa6] MAINTAINERS: update SFI pattern
git bisect good 943fc810bdc9c0fce5cc66bdb65b42d699241aa6
# good: [3486740a4f32a6a466f5ac931654d154790ba648] userns: security: make capabilities relative to the user namespace
git bisect good 3486740a4f32a6a466f5ac931654d154790ba648
# good: [38d2620ea40c2f9a5f17d6488bf004973570279c] svga: Make svga_set_timings() take an iomem regbase pointer.
git bisect good 38d2620ea40c2f9a5f17d6488bf004973570279c
# good: [2f284c846331fa44be1300a3c2c3e85800268a00] Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm
git bisect good 2f284c846331fa44be1300a3c2c3e85800268a00
# good: [d6244bc0ed0c52a795e6f4dcab3886daf3e74fac] fbcon: Bugfix soft cursor detection in Tile Blitting
git bisect good d6244bc0ed0c52a795e6f4dcab3886daf3e74fac
# good: [26947f8c8f9598209001cdcd31bb2162a2e54691] proc: disable mem_write after exec
git bisect good 26947f8c8f9598209001cdcd31bb2162a2e54691
# good: [d958c62c0cf43bb9c7dcd9833a35335ae72856f7] MAINTAINERS: Add file pattern for fb dt bindings.
git bisect good d958c62c0cf43bb9c7dcd9833a35335ae72856f7
# good: [198214a7ee50375fa71a65e518341980cfd4b2f0] proc: enable writing to /proc/pid/mem
git bisect good 198214a7ee50375fa71a65e518341980cfd4b2f0
# good: [b81a618dcd3ea99de292dbe624f41ca68f464376] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
git bisect good b81a618dcd3ea99de292dbe624f41ca68f464376
# good: [56be1416453c31d32f984328b5193489ab63ffcf] MAINTAINERS: de-orphan fbdev.
git bisect good 56be1416453c31d32f


Thanks,
Ben

>
> Jeff
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

