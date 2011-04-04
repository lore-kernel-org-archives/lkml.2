Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab1DDOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:16:59 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58135 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab1DDOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:16:58 -0400
Date: Mon, 4 Apr 2011 23:16:52 +0900
From: Norbert Preining <preining@logic.at>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org
Subject: Re: Lenovo resume from suspends hangs in i915_gpu_busy or so
Message-ID: <20110404141652.GB13658@gamma.logic.tuwien.ac.at>
References: <20110401021055.GB6071@gamma.logic.tuwien.ac.at> <20110401051511.GE9128@gamma.logic.tuwien.ac.at> <20110401090817.01717af0@jbarnes-desktop> <20110402002410.GL6464@gamma.logic.tuwien.ac.at> <20110401192106.2cca8cd7@jbarnes-x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110401192106.2cca8cd7@jbarnes-x200>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse, hi everyone,

ok, I give up for now. 

On Fr, 01 Apr 2011, Jesse Barnes wrote:
> Well I'd start with something like 2.6.37, I think that's the first

2.6.37 suspends and resumes fine, even with X running

Then I recompiled 2.6.39-rc1 with our patch and suspended,
resume took 1min (exactely!) and worked out. I got a lot of the
warning messages, every five seconds the DRM_ERROR msgs from
the patch.
[   52.069753] [drm:i915_gpu_busy] *ERROR* entering busy check, trying to take lock
[   52.071813] [drm:i915_gpu_busy] *ERROR* got lock, returning current busy status
[   52.074233] [drm:i915_gpu_busy] *ERROR* unlock & return
[   57.074194] [drm:i915_gpu_busy] *ERROR* entering busy check, trying to take lock
[   57.076270] [drm:i915_gpu_busy] *ERROR* got lock, returning current busy status
[   57.078717] [drm:i915_gpu_busy] *ERROR* unlock & return


The resume was probably hanging at something different. I am not at 
the laptop now (travelling with a ifferent laptop), but it was:
	r8169: cannot apply firmware patch 
or something similar. It was always ... resume ... 60sec hang ...
then this message and "resume of devices completed" or so in the dmesg
output.

So I thought it might be that the patch changed a bit of timings 
but recompiling *without* the patch and rebooting I get now the
same behaviour: Suspend and resume works, although hanging for 1min
before coming back.

I guess that means we can close that problem for now.

Sorry for the noise. If someone has an ide awhere to search for
the "cannot apply firmware patch" problem please let me know.

Thanks and all the best

Norbert

------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
TILLICOULTRY (n.)
The man-to-man chumminess adopted by an employer as a prelude for
telling an employee that he's going to have to let him go.
			--- Douglas Adams, The Meaning of Liff
