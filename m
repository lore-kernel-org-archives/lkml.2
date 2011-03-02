Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab1CBX5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:57:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756119Ab1CBX53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:57:29 -0500
Date: Wed, 2 Mar 2011 15:56:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Ornati <ornati@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [2.6.38-rc6] G965: i915 Hangcheck timer elapsed... GPU hung
 (not reproducible)
Message-Id: <20110302155648.421f0292.akpm@linux-foundation.org>
In-Reply-To: <20110227101041.6b864352@gmail.com>
References: <20110227101041.6b864352@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc dri-devel)

A post-2.6.37 regression.

On Sun, 27 Feb 2011 10:10:41 +0100
Paolo Ornati <ornati@gmail.com> wrote:

> Today I got this while starting a video in SMplayer (MPlayer) with
> 2.6.38-rc6-00113-g4662db4:
> 
> [  830.880014] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> [  830.880736] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -11 (awaiting 174895 at 174857, next 174896)
> [  830.881093] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 00000000 head 00000000 tail 00000000 start 00000000
> [  831.379079] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
> [  831.399099] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
> 	...
> [  837.392012] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> [  837.392038] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -11 (awaiting 175016 at 174857, next 175022)
> [  837.392491] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 00000000 head 00000000 tail 00000000 start 00000000
> [  837.537479] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
> [  837.543285] [drm:i915_do_wait_request] *ERROR* something (likely vbetool) disabled interrupts, re-enabling
> 	...
> [  839.040011] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> [  839.040034] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -11 (awaiting 175022 at 174857, next 175122)
> [  839.040364] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
> [  839.040367] [drm:i915_reset] *ERROR* Failed to reset chip.
> 
> Screen was almost freezed, cursor was stuck but the machine was alive
> and I was able to use SysRq to kill X and try to restart it (but that
> didn't help).
> 
> I don't remember anything similar in recent kernels (<= 2.6.37) and got
> this only once with 2.6.38-rcX.
> 
> Environment at the time of the GPU crash:
> 	KDE4 (without "Desktop Effects")
> 	Chromium
> 	Claws Mail
> 	Dolphin
> 	ccached make -j3 on a just pulled linux-tree (so I/O bound)
> 	SMPlayer/Mplayer (just launched)
> 
> Assorted logs attached.
> 

