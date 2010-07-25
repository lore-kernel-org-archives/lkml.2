Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0GYPFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 11:05:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:50558 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab0GYPFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 11:05:50 -0400
Message-Id: <89kc63$hi6qh3@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,257,1278313200"; 
   d="scan'208";a="589523502"
Date: Sun, 25 Jul 2010 16:05:45 +0100
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Dan Carpenter <error27@gmail.com>
Subject: Re: [patch] i915: take struct_mutex in i915_dma_cleanup()
Cc: David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
        Zhenyu Wang <zhenyuw@linux.intel.com>, nanhai.zou@intel.com,
        Benny Halevy <bhalevy@panasas.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, "Jin, Gordon" <gordon.jin@intel.com>
References: <20100623111954.GA16433@bicker> <20100623084718.2dfe6e7f@virtuousgeek.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100623084718.2dfe6e7f@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 08:47:18 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> Reminds me, Gordon can you add module unload testing to your set of
> basic daily tests?  To unload you need to unbind the fbcon interface
> first, my script is like this:
> 
> echo 0 > /sys/class/vtconsole/vtcon1/bind
> rmmod i915
> rmmod drm_kms_helper
> rmmod drm
> modprobe i915
> echo 1 > /sys/class/vtconsole/vtcon1/bind

To which we could even add a kmemleak check.
After rmmod drm and before reloading i915:
echo scan > /sys/kernel/debug/kmemleak
cat /sys/kernel/debug/kmemleak > `hostname`-leaks.txt

If the output is not empty, file a bug. [Of course this means having to
compile kmemleak into the kernel. The DEBUG_KMEMLEAK option is found under
Kernel Hacking.] And since each generation has slightly different
initialization stanzas, we need to repeat the test on all platforms.
-- 
Chris Wilson, Intel Open Source Technology Centre
