Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1C2HLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:11:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51682 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1C2HLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eA2+yDGwLSprrh8Uv3+M5j1yGBrQIe/WbTzB6YT7EV/JxOvb2ZkhLsn/wLRXHa2L6i
         HiSjE2Tbz83stOO2MYDwCgJLoUTiQdh00lu8ljsGJRHuwmTCQTa496WxLBySPPkwuhK+
         IDn8eel2q+uFDTaRKNiqfYYcsVfwTBWTZUeEY=
MIME-Version: 1.0
In-Reply-To: <849307$c6tdto@azsmga001.ch.intel.com>
References: <alpine.DEB.2.00.1103241132001.12023@skynet.skynet.ie>
	<AANLkTi=g27c3_Meu-YymXNPSD+isonN7CuWg78F9ZA+j@mail.gmail.com>
	<AANLkTimAwNytQaykaMf33DUXcKOyGVWUetOAb_nf236t@mail.gmail.com>
	<849307$c6tdto@azsmga001.ch.intel.com>
Date: Tue, 29 Mar 2011 10:11:21 +0300
X-Google-Sender-Auth: M-JKpK1uMfhyhQE73MK7IaRdQUQ
Message-ID: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
Subject: Re: [git pull] drm fixes for -rc1
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:09 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Mon, 28 Mar 2011 21:53:32 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>> On Mon, Mar 28, 2011 at 9:43 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> > On Thu, Mar 24, 2011 at 1:34 PM, Dave Airlie <airlied@linux.ie> wrote:
>> >> It should have the fix for your i915 in the intel patches, along with
>> >> a couple of radeon fixes, and the vblank change + fix.
>> >
>> > I'm seeing some laptop screen flicker during boot and a while after I
>> > log in (it then seems to go away). It's my trusty old Macbook with
>> > i915 and Ubuntu 10.04. I see this in dmesg:
>> >
>> > [    1.782046] [drm] initialized overlay support
>> > [    1.782075] [drm] capturing error event; look for more information
>> > in /debug/dri/0/i915_error_state
>> > [    1.782889] render error detected, EIR: 0x00000010
>> > [    1.782933] page table error
>> > [    1.782970]   PGTBL_ER: 0x00000102
>> > [    1.783009] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck:
>> > 0x00000010, masking
>> > [    1.783063] render error detected, EIR: 0x00000010
>> > [    1.783106] page table error
>> > [    1.783143]   PGTBL_ER: 0x00000102
>> >
>> > I'm attaching the full dmesg, i915_error_state, and .config.
>
> Right, looks like we have an issue with setting up the hardware for
> KMS/GEM whilst it is still active. As we disable the outputs anyway for
> the KMS takeover, we can arrange to do so first and so prevent this bug.
> The side-effect will be that initial screen blanking will last a little
> bit longer.

Let me know if there's a patch/git tree to test. The flicker is
extremely annoying and I boot the machine often because it's my main
kernel development laptop.

>> I'm also seeing these errors now which seem to be new from 2.6.38-final:
>>
>> [  437.566022] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
>> purgeable buffer
>> [  437.566187] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
>> purgeable buffer
>> [  437.566232] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
>> purgeable buffer
>> [  437.566275] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
>> purgeable buffer
>> [  437.566318] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a
>> purgeable buffer
>
> That's an old userspace bug, which so far no one has been able to
> reproduce on the upstream ddx.

Is it harmless? Why is the kernel complaining about it?
