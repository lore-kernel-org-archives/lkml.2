Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab1CXMMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:12:45 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:49286 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab1CXMMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:12:43 -0400
Message-ID: <4D8B33A2.4090105@snapgear.com>
Date: Thu, 24 Mar 2011 22:05:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/1] m68k: merge m68k and m68knommu arch directories
References: <1300768985-902-1-git-send-email-gerg@snapgear.com>	<AANLkTimHzPn2Xe1RVRQKjwdynDvc3iL2=8kJ1p8kRZQ4@mail.gmail.com>	<AANLkTi=ohXGdwfAtWmDJKCq+cJtFqJdTCmPCxFOg6dY6@mail.gmail.com>	<4D8A89E7.6060204@snapgear.com> <AANLkTi=O76yY1NtiX5EVCA7=kGB6Tj1UsuXigKwZdKUk@mail.gmail.com>
In-Reply-To: <AANLkTi=O76yY1NtiX5EVCA7=kGB6Tj1UsuXigKwZdKUk@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/11 18:04, Geert Uytterhoeven wrote:
> On Thu, Mar 24, 2011 at 01:01, Greg Ungerer<gerg@snapgear.com>  wrote:
>> Hi Geert,
>>
>> On 24/03/11 08:14, Geert Uytterhoeven wrote:
>>>
>>> On Wed, Mar 23, 2011 at 23:07, Geert Uytterhoeven<geert@linux-m68k.org>
>>> áwrote:
>>>>
>>>> On Tue, Mar 22, 2011 at 05:43, ├í<gerg@snapgear.com>  áwrote:
>>>>>
>>>>> The following patch merges the m68k and m68knommu arch directories.
>>>>> This patch has been trimmed for review purposes - the automated file
>>>>> moving and mergeing carried out by the script contained in this email
>>>>> has been removed. Only the manually required changes after running the
>>>>> script are shown as the patch. (So to end up with the final required
>>>>> change you need to run this script then apply the patch).
>>>>>
>>>>> This change is available as the only commit on the m68knommu git tree,
>>>>> for-linux branch:
>>>>>
>>>>> The following changes since commit
>>>>> a952baa034ae7c2e4a66932005cbc7ebbccfe28d:
>>>>> ├íLinus Torvalds (1):
>>>>> ├í ├í ├í ├íMerge branch 'for-linus' of
>>>>> git://git.kernel.org/.../dtor/input
>>>>>
>>>>> are available in the git repository at:
>>>>>
>>>>> ├ígit://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
>>>>> for-linus
>>>>>
>>>>> Greg Ungerer (1):
>>>>> ├í ├í ├ím68k: merge m68k and m68knommu arch directories
>>>>>
>>>>>
>>>>> It is also on the for-next branch in that tree, so will get some testing
>>>>> in the next tree for the next few days.
>>>>
>>>> defconfig is now a nommu-config, and it fails?
>>>
>>> BTW, haven't tried it myself yet. I'm busy bisecting an issue with
>>> initrds, which
>>> got introduced between 2.6.37 and 2.6.38.
>>>
>>> Init fails with "init: cannot open inittab", followed by
>>> "Kernel panic - not syncing: Attempted to kill init!".
>>>
>>> As I can't get ramdisks to work on ARAnyM, I need to use real hardware,
>>> which
>>> suffers a lot from long reboot/copy kernel/test cycles...
>>
>> As one data point (though not sure how useful this is to you... :-)
>> I can compile for an Atari target with the merge tree and load it
>> and run it on ARAnyM - using a ramdisk for root fs. Seems to work
>> ok.
>
> Strange. On ARAnyM I get:
>
>      Trying to unpack rootfs image as initramfs...
>      rootfs image is not initramfs (junk in compressed archive); looks
> like an initrd
>      Freeing initrd memory: 350k freed

I see that too.


> but later it fails with:
>
>      RAMDISK: Couldn't find valid RAM disk image starting at 0.

But later I get:

RAMDISK: ext2 filesystem found at block 0
RAMDISK: Loading 4096KiB [1 disk] into ram disk... done.
VFS: Mounted root (ext2 filesystem) readonly on device 1:0.


BTW the command boot args are:

Kernel command line: root=/dev/ram load_ramdisk=1 ramdisk_size=4096 
video=atafb:tthigh console=tty0 debug stram_swap=0 BOOT_IMAGE=vmlinux

> It "works" (i.e. mounts) on the Amiga, but later it fails with the
> inittab error.
> Will  bisect more tonight...

Good luck :-)

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
