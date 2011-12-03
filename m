Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1LCPU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 10:20:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35860 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1LCPUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 10:20:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAGPN=9Qh44WusZm_z6G-cM87LMVVOe9bur4sJzpHGwu-dtCsJQ@mail.gmail.com>
References: <CAGPN=9Q8gB_xsbB1BrMJSo_Qs=7Tu49RX4x3VqNB9adzVdm6kg@mail.gmail.com>
	<4ED8039F.4090104@mit.edu>
	<CAGPN=9T2tSK43NgMA=6T=jUqBnOT-6PXq8FeQXjSgGoDW1==1A@mail.gmail.com>
	<CAObL_7FZVwOvc4SPaQXoD0M=a5sNhTkFAT0dhBFedGBDXt5P0Q@mail.gmail.com>
	<CAGPN=9Qh44WusZm_z6G-cM87LMVVOe9bur4sJzpHGwu-dtCsJQ@mail.gmail.com>
Date: Sat, 3 Dec 2011 16:20:23 +0100
Message-ID: <CAGPN=9Q3S0z9aWHyGYPRBfA-iywtJE708v90GDQrpigMVPa-Xg@mail.gmail.com>
Subject: Re: i915: RC6 causes sudden shutdowns
From: Patrik Kullman <patrik.kullman@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/3 Patrik Kullman <patrik.kullman@gmail.com>:
> 2011/12/2 Andrew Lutomirski <luto@mit.edu>:
>> On Thu, Dec 1, 2011 at 9:00 PM, Patrik Kullman <patrik.kullman@gmail.com> wrote:
>>> 2011/12/1 Andy Lutomirski <luto@mit.edu>:
>>>> On 11/23/2011 03:43 PM, Patrik Kullman wrote:
>>>>> Hi,
>>>>>
>>>>> I recently acquired the Asus Zenbook UX31E but have been looking for
>>>>> ways to extend the battery life.
>>>>>
>>>>> I read that the i915_enable_rc6 parameter could decrease power usage
>>>>> significantly and tried it with the 3.1.1 and 3.1.2 kernels, and
>>>>> indeed it does.
>>>>> However, I (and the other Zenbook-owners from the Ubuntu forums)
>>>>> experience sudden, unexpected shutdowns (for me, 1-4 times per day)
>>>>> with this parameter.
>>>>> It's as sudden as a power loss.
>>>>
>>>> Do you have DMAR enabled?  If so, it's a known problem and it's being
>>>> worked on (and the default will not change for you AFAICT).  If not, you
>>>> should send a bug report to the intel-gfx -- several people there care
>>>> about this.
>>>>
>>>> --Andy
>>>
>>> Well, it's not something I've explicitly enabled.
>>>
>>> Is it on by default?
>>
>> Depends on config options.  You can probably get a good idea by
>> looking for "DMAR" in your kernel log.
>>
>>>
>>> If so, any reason why I wouldn't want to disable it?
>>
>> There are three reasons to enable it:
>>
>> 1. If you're paranoid and want to (partially) protect your system
>> against malicious PCI/PCIe cards.
>> 2. If you assign devices in your system to VM guests.
>> 3. If you have more than 4GB of RAM and you have DMA-capable devices
>> that can only address 32 bits, then you might get a performance boost.
>>
>> In other words, for normal desktop use, you don't need it.  Try
>> booting with intel_iommu=off.
>>
>> --Andy
>
> As reported by another Ubuntu Zenbook user
> (http://ubuntuforums.org/showpost.php?p=11507684&postcount=207):
>
> Sadly i still get random shutdowns with 3.2-rc4. I have noticed that
> if i just leave my computer on, and does not use it (i have disabled
> the screensaver), the crashes does not accrue.
>
> GRUB_CMDLINE_LINUX_DEFAULT="quiet splash drm.debug=4 intel_iommu=off
> i915.modeset=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1
> i915.i915_enable_rc6=1 pcie_aspm=force"

Something worth mentioning is that the combination of pcie_aspm=force
and intel_iommu=off results in i915.modeset=0, with this combination,
I have to specify i915.modeset=1 to get hardware acceleration.

However, only specifying i915.i915_enable_rc6=1 and intel_iommu=off
keeps modeset=1.

Also I can confirm RC6 and iommu off still causes unexpected
shutdowns, even when booting without FBC, LVDS downclock and
pcie_aspm=force.
