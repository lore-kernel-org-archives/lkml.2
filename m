Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1DELzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 07:55:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37241 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1DELzL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 07:55:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=n50SwBhPPZCplpyNe2KZGDHPfmAXrt/kV9awxRTH3hEr9N79YO4odar/zbn02uXlxg
         KNXzS8vmeD20Q+F7FlXL7MT7n4qWQiSiS03SKsl1m5Pl8/Kv1n5emCjk4Q02XbYM4PnO
         kGWUz4iIA1OfsSzTVKMas3UIlRPbXWOg0+vYY=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=kXod21RUukrTuMzP5TFqgo4NxRw@mail.gmail.com>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
	<1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<20110401114429.GA3526@viiv.ffwll.ch>
	<AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com>
	<BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com>
	<b7da2f$qvoau5@fmsmga001.fm.intel.com>
	<BANLkTi=kXod21RUukrTuMzP5TFqgo4NxRw@mail.gmail.com>
Date: Tue, 5 Apr 2011 14:55:10 +0300
Message-ID: <BANLkTimhs1vZMbD4eiuCxBnU35bijj91tw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before
 KMS takeover
From: Tomas Winkler <tomasw@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 1:37 PM, Pekka Enberg <penberg@kernel.org> wrote:
> Hi Chris!
>
> On Tue, Apr 5, 2011 at 1:30 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> On Tue, 5 Apr 2011 13:21:08 +0300, Tomas Winkler <tomasw@gmail.com> wrote:
>>> On Fri, Apr 1, 2011 at 2:51 PM, Pekka Enberg <penberg@kernel.org> wrote:
>>> > Unfortunately I get a blank screen with after boot:
>>> > Nacked-by: Pekka Enberg <penberg@kernel.org>
>>
>> But until you can tell me where it explodes on your system, we fix
>> issues on several other machines...
>
> Oh, that's nice, you first made the damn thing flicker in 2.6.39-rc1
> and now you're fixing it for others by giving me a blank screen after
> boot?
>
> I guess I don't need to tell you that I am not at all happy especially
> since you keep breaking i915 in almost every damn release!
>
>>> Not sure this is related, but when I enable DRM_I915_KMS=y I'm got
>>> stuck after boot too. When KMS is disabled I can at least get to the
>>> console (no graphics)
>>> This is with kernel 2.6.39-rc1.  It worked fine with 2.6.38. I don't
>>> have much time bisect and reboot.  Shell I  try to pull drm-fixes for
>>> rc2 or use try this patch?

merging drm-fixes for rc2 definitely helped booting.

>> Add drm.debug=0xe to your grub kernel parameters and attach the dmesg for
>> the failing boot. From that I should be able to recommend a course of
>> action.

There are some error messages

   4.311738] [drm:intel_crt_init], pch crt adpa set to 0xf40000
[    4.311792] [drm:intel_dp_i2c_init], i2c_init DPDDC-C
[    4.312300] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[    4.312302] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    4.312814] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[    4.312815] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    4.312848] [drm:intel_dp_i2c_init], i2c_init DPDDC-D
[    4.313357] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[    4.313358] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    4.313866] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003e
[    4.313868] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    4.313886] [drm:intel_panel_get_backlight], get backlight PWM = 0
[    4.313891] vgaarb: device changed decodes:
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    4.314378] [drm:ironlake_crtc_dpms], crtc 0/0 dpms off
[    4.314381] [drm:i915_get_vblank_timestamp], crtc 0 is disabled
[    4.343908] [drm:intel_update_fbc],
[    4.343910] [drm:ironlake_crtc_dpms], crtc 1/1 dpms off
[    4.343912] [drm:gm45_get_vblank_counter], trying to get vblank
count for disabled pipe B
[    4.343914] [drm:i915_get_vblank_timestamp], crtc 1 is disabled
[    4.343916] [drm:gm45_get_vblank_counter], trying to get vblank
count for disabled pipe B
[    4.344555] [drm:intel_update_fbc],
[    4.344559] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:5:VGA-1]
[    4.344562] [drm:intel_ironlake_crt_detect_hotplug], trigger
hotplug detect cycle: adpa=0xf40000
[    4.354477] [drm:intel_ironlake_crt_detect_hotplug], ironlake
hotplug adpa=0xf40000, result 0
[    4.354483] [drm:intel_crt_detect], CRT not detected via hotplug
[    4.354488] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:5:VGA-1] disconnected
[    4.354493] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:8:HDMI-A-1]
[    4.364484] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:8:HDMI-A-1] disconnected
[    4.364491] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:12:HDMI-A-2]
[    4.416299] [drm] GMBUS timed out, falling back to bit banging on
pin 7 [i915 gmbus dpd]
[    4.537460] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:12:HDMI-A-2] probed modes :
[    4.537462] [drm:drm_mode_debug_printmodeline], Modeline
21:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48
0x5

Tomas
