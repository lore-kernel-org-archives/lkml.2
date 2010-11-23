Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0KWVgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:36:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51663 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0KWVgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:36:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hsQiuRr53arCQBCelvdmGfjRJSLlVnPrreTOeva7mzHNHnZYk2zCeLeQQSLxxhLtQb
         II1aDo0Ezp+ro2akoU6SCbq7/26o9GO4vkQivwvSwHUPt3W2NTGio5MdRTFEutQH1Z3/
         NlCiunLd3bikQQkDxjfAs6cnze+D2LlEuNKpU=
MIME-Version: 1.0
In-Reply-To: <b9dded$h5thli@orsmga002.jf.intel.com>
References: <AANLkTinEbBirwkREAVaaB4gH0w44tem0ik9nPU5-6aNJ@mail.gmail.com>
 <c6d829$pk1i4l@fmsmga001.fm.intel.com> <4CE95893.8040008@gmail.com> <b9dded$h5thli@orsmga002.jf.intel.com>
From: Vincent Vanackere <vincent.vanackere@gmail.com>
Date: Tue, 23 Nov 2010 22:36:10 +0100
Message-ID: <AANLkTikfFL5v=+6Q6-QTTA1cp9u19R=Vkn8mwyA4Rqdh@mail.gmail.com>
Subject: Re: [i915] 2.6.37-rc1 G33 regression : no DVI output
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 10:08 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Sun, 21 Nov 2010 18:36:19 +0100, Vincent Vanackere <vincent.vanackere@gmail.com> wrote:
>> [    8.740024] [drm:drm_crtc_helper_set_mode], [ENCODER:7:TMDS-7] set [MODE:13:1920x1200]
>> [    8.740027] [drm:intel_sdvo_debug_write], SDVOB: W: 07 01 00 00 00             (SDVO_CMD_SET_IN_OUT_MAP)
>> [    8.747826] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
>> [    8.747828] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
>> [    8.753161] [drm:intel_sdvo_debug_write], SDVOB: W: 11 01 00                   (SDVO_CMD_SET_TARGET_OUTPUT)
>> [    8.758485] [drm:intel_sdvo_debug_write], SDVOB: W: 16 28 3C 80 A0 70 B0 23 40 (SDVO_CMD_SET_OUTPUT_TIMINGS_PART1)
>> [    8.771225] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
>> [    8.771227] [drm:intel_sdvo_debug_write], SDVOB: W: 10 00                      (SDVO_CMD_SET_TARGET_INPUT)
>> [    8.775340] [drm:intel_sdvo_debug_write], SDVOB: W: 93 01 00                   (SDVO_CMD_SET_HBUF_INDEX)
>> [    8.780688] [drm:intel_sdvo_write_cmd], command returns response Not supported [2]
>
> This was the bug. We aborted the modeset as we tried to perform an
> unsupported command. Should be fixed by:
>
> commit da79de97d254145dcb7c08c978b1093eac15ec9c
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Mon Nov 22 11:12:46 2010 +0000
>

Thanks ! This patch indeed fixes my bug.

Best regards,

Vincent
