Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1CYVka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:40:30 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41377 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755134Ab1CYVk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:40:29 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 1/3] tea575x-tuner: various improvements
Date: Fri, 25 Mar 2011 22:40:12 +0100
User-Agent: KMail/1.9.10
Cc: "Takashi Iwai" <tiwai@suse.de>, jirislaby@gmail.com,
        alsa-devel@alsa-project.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <201103121919.05657.linux@rainbow-software.org> <201103191632.58347.linux@rainbow-software.org> <201103222002.31074.hverkuil@xs4all.nl>
In-Reply-To: <201103222002.31074.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103252240.16051.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 March 2011 20:02:30 Hans Verkuil wrote:
> BTW, can you run the v4l2-compliance utility for the two boards that use
> this radio tuner?
>
> This utility is part of the v4l-utils repository
> (http://git.linuxtv.org/v4l-utils.git).
>
> Run as 'v4l2-compliance -r /dev/radioX -v2'.
>
> I'm sure there will be some errors/warnings (warnings regarding
> G/S_PRIORITY are to be expected). But I can use it to make a patch for
> 2.6.40 that fixes any issues.

The output is the same for both fm801 and es1968 (see below). Seems that
there are 4 errors:
 1. multiple-open does not work
 2. something bad with s_frequency
 3. input functions are present
 4. no extended controls



Running on 2.6.38

Driver Info:
	Driver name   : tea575x-tuner
	Card type     : TEA5757
	Bus info      : PCI
	Driver version: 0.0.2
	Capabilities  : 0x00050000
		Tuner
		Radio

Compliance test for device /dev/radio0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second radio open: FAIL

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: Not Supported
	test VIDIOC_DBG_G/S_REGISTER: Not Supported
	test VIDIOC_LOG_STATUS: Not Supported

Input ioctls:
	test VIDIOC_G/S_TUNER: OK
		fail: set rangehigh+1 frequency did not return EINVAL
	test VIDIOC_G/S_FREQUENCY: FAIL
	test VIDIOC_ENUMAUDIO: Not Supported
		fail: radio can't have input support
	test VIDIOC_G/S/ENUMINPUT: FAIL
	test VIDIOC_G/S_AUDIO: Not Supported
	Inputs: 0 Audio Inputs: 0 Tuners: 1

Output ioctls:
	test VIDIOC_G/S_MODULATOR: Not Supported
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: Not Supported
	test VIDIOC_G/S/ENUMOUTPUT: Not Supported
	test VIDIOC_G/S_AUDOUT: Not Supported
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
		fail: does not support V4L2_CTRL_FLAG_NEXT_CTRL
	test VIDIOC_QUERYCTRL/MENU: FAIL
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: Not Supported
	Standard Controls: 0 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: Not Supported
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
	test VIDIOC_G/S_DV_TIMINGS: Not Supported

Total: 21 Succeeded: 17 Failed: 4 Warnings: 0

-- 
Ondrej Zary
