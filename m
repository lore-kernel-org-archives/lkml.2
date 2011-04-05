Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1DEKVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 06:21:12 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37478 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1DEKVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 06:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=ZOOcEiwRz80VHToAGFgpGOX18MyZLryVDlRa/kncodOLaQJxNTn7uQkIrfYteF2Vnp
         rnsj2S4z9kMX0xc64hEBZqG3y87XYHDMJ8YiojZGghedrYdj620SNi9N5htrgauBge7W
         x/sLtGoxqBRS1cobJz3NlU9dgxYihi7mqt2bY=
MIME-Version: 1.0
In-Reply-To: <AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
	<1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<20110401114429.GA3526@viiv.ffwll.ch>
	<AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com>
Date: Tue, 5 Apr 2011 13:21:08 +0300
Message-ID: <BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before
 KMS takeover
From: Tomas Winkler <tomasw@gmail.com>
To: Pekka Enberg <penberg@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 2:51 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Fri, Apr 1, 2011 at 2:44 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Tue, Mar 29, 2011 at 11:46:29AM +0100, Chris Wilson wrote:
>>> If the outputs are active and continuing to access the GATT when we
>>> teardown the PTEs, then there is a potential for us to hang the GPU.
>>> The hang tends to be a PGTBL_ER with either an invalid host access or
>>> an invalid display plane fetch.
>>
>> This patch seems to fix resume flakiness (that recently developed
>> complete reliability in hanging the gpu) on my i855gm. Captured
>> error_states look as described here. Latest -staging merged into latest
>> -linus is now again fully reliable at s/r.
>>
>> Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> Unfortunately I get a blank screen with after boot:
> Nacked-by: Pekka Enberg <penberg@kernel.org>

Not sure this is related, but when I enable DRM_I915_KMS=y I'm got
stuck after boot too. When KMS is disabled I can at least get to the
console (no graphics)
This is with kernel 2.6.39-rc1.  It worked fine with 2.6.38. I don't
have much time bisect and reboot.  Shell I  try to pull drm-fixes for
rc2 or use try this patch?


lspci -vv
00:02.0 VGA compatible controller: Intel Corporation Core Processor
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Intel Corporation Device 0036
	Flags: bus master, fast devsel, latency 0, IRQ 42
	Memory at fe000000 (64-bit, non-prefetchable) [size=4M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at f160 [size=8]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: <access denied>
	Kernel driver in use: i915
	Kernel modules: i915

Thanks
Tomas
