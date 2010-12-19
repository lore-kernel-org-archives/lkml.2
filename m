Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0LSLD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 06:03:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:58184 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab0LSLD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 06:03:28 -0500
Message-Id: <5b55a1$j0e7cc@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,196,1291622400"; 
   d="scan'208";a="638000524"
Date: Sun, 19 Dec 2010 11:02:20 +0000
To: sclark46@earthlink.net
Subject: Re: I915 driver locks up
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4D0D44A1.8090501@earthlink.net>
References: <4D0D1516.3040404@earthlink.net> <4D0D19FF.4020600@earthlink.net> <5b55a1$j0av6h@fmsmga002.fm.intel.com> <4D0D44A1.8090501@earthlink.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010 18:32:49 -0500, Stephen Clark <sclark46@earthlink.net> wrote:
> I had been using mesa-7.9.
> I loaded mesa-7.10 similar results. There is no
> 
> /sys/kernel/debug/dri/0/i915_error_state
> 
> In fact there is nothing in the /sys/kernel/debug directory. Do I have 
> to enable
> something.

You need to "mount -tdebugfs debug /sys/kernel/debug".
 
> With the later kernel - things are worse X becomes totally useless it looks
> like my lcd panel lost horizontal sync. With the 2.6.25 kernel X is 
> still usable
> this makes me think at least some of the problem is kernel related.

2.6.25 to present marks the transition between UMS and KMS, i.e. moving
of the userspace modesetting code into the kernel. And that should not
have regressed. Can you please, grab an intel_reg_dumper of the working
setup and the lost-sync setup, and include a drm.debug=0xe dmesg (i.e. add
drm.debug=0xe to your boot commandline)?
 
> With 2.6.37-rc6 and mesa 7.10 with hardware acceleration turned off in wine-
> 
> Dec 18 18:01:50 joker4 yum[5244]: Updated: mesa-libGL-7.10-0.17.fc15.x86_64
> Dec 18 18:01:52 joker4 yum[5244]: Updated: mesa-libGL-7.10-0.17.fc15.i686
> Dec 18 18:01:54 joker4 yum[5244]: Updated: mesa-libGLU-7.10-0.17.fc15.x86_64
> Dec 18 18:02:02 joker4 yum[5244]: Updated: mesa-dri-drivers-7.10-0.17.fc15.x86_6
> 4
> Dec 18 18:02:03 joker4 yum[5244]: Updated: mesa-libGLU-7.10-0.17.fc15.i686
> Dec 18 18:02:11 joker4 yum[5244]: Updated: mesa-dri-drivers-7.10-0.17.fc15.i686

Good, those drivers are recent enough that I should be able to use the
error state to find the broken code.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
