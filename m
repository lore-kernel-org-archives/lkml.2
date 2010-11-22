Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab0KVIgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:36:22 -0500
Received: from daytona.panasas.com ([67.152.220.89]:11304 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab0KVIgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:36:21 -0500
Message-ID: <4CEA2B80.10301@panasas.com>
Date: Mon, 22 Nov 2010 10:36:16 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Chris Vine <chris@cvine.freeserve.co.uk>
CC: Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel 2.6.37-rc2 breaks i915 graphics
References: <20101121102344.7c590b99@laptop.homenet>	<0d30dc$k822nk@orsmga001.jf.intel.com> <20101121183423.0f7c1872@laptop.homenet>
In-Reply-To: <20101121183423.0f7c1872@laptop.homenet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Nov 2010 08:36:18.0293 (UTC) FILETIME=[552F2250:01CB8A20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2010 08:34 PM, Chris Vine wrote:
> On Sun, 21 Nov 2010 10:30:43 +0000
> Chris Wilson <chris@chris-wilson.co.uk> wrote:
> 
>> On Sun, 21 Nov 2010 10:23:44 +0000, Chris Vine
>> <chris@cvine.freeserve.co.uk> wrote:
>>> Hi,
>>>
>>> With kernel 2.6.37-rc2, i915 graphics usually fails on boot-up after
>>> modesetting with my Lenovo S12 netbook which uses the Intel 945GME
>>> Express Integrated Graphics Controller.  It displays up to the
>>> point at which modesetting takes place and then usually goes blank.
>>>
>>> There may be some kind of race at work here: first, sometimes
>>> (maybe 1 times in 4) graphics comes up correctly on a first cold
>>> boot, but I have never managed to get it to come up on a warm
>>> reboot. Secondly, graphics can be restored when I know (but cannot
>>> see) that boot-up has concluded, simply by suspending the laptop
>>> and then resuming.  Resuming the laptop after a suspend always
>>> brings up the graphics correctly.
>>
>> Add drm.debug=0xe to your boot commandline and compare if there is any
>> difference between a successful cold boot, a broken cold boot and a
>> warm boot. Similarly, comparing the output of intel_reg_dumper after
>> each should yield a few clues as to what stage in the boot process we
>> fail. -Chris
> 
> First an additional datum point: 2.6.37-rc1 works normally, so the bug
> is something introduced between 2.6.37-rc1 and 2.6.37-rc2 (to that
> extent it may be related to this bug which reports a similar phenomenon:
> http://lkml.org/lkml/2010/11/21/23 ).
> 
> Attached is the dmesg output from a successful cold boot with
> 2.6.37-rc2, an unsuccessful cold boot and an unsuccessful warm boot,
> each with drm.debug=0xe.
> 
> I can't provide the output of intel_reg_dumper:  I can't compile the
> latest intel-gpu-tools from git (missing declaration/definition of
> I915_EXE_BLT).  Probably something in a relevant library is too old.
> 
> Chris

Do you know / can do a "git bisect" good 2.6.37-rc1 bad 2.6.37-rc2
should not be that long. This will pinpoint the bug to a specific
patch.

Thanks
Boaz

