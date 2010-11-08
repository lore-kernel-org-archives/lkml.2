Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0KHKUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:20:37 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:46807 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab0KHKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:20:36 -0500
Subject: Re: [Intel-gfx] [bisected] offset display bug in i915
From: Jon Masters <jonathan@jonmasters.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
References: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 05:20:58 -0500
Message-ID: <1289211658.3916.384.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 05:18 -0500, Jon Masters wrote:

> The following patch that you recently committed breaks my ASUS Eee PC
> 1015PEM by causing the display to be offset by about 1 inch (a few
> centimeters) when the mode is (re)set during boot. I previously posted
> both photographs and video of the problem in another "PROBLEM" thread.

Here's my bisection log, for the record.

git bisect start
# good: [f6f94e2ab1b33f0082ac22d71f66385a60d8157f] Linux 2.6.36
git bisect good f6f94e2ab1b33f0082ac22d71f66385a60d8157f
# bad: [c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4] Linux 2.6.37-rc1
git bisect bad c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4
# good: [33081adf8b89d5a716d7e1c60171768d39795b39] Merge branch
'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect good 33081adf8b89d5a716d7e1c60171768d39795b39
# bad: [00ebb6382b8d9c7c15b5f8ad230670d8161d38dd] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc
git bisect bad 00ebb6382b8d9c7c15b5f8ad230670d8161d38dd
# good: [520045db940a381d2bee1c1b2179f7921b40fb10] Merge branches
'upstream/xenfs' and 'upstream/core' of
git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen
git bisect good 520045db940a381d2bee1c1b2179f7921b40fb10
# bad: [60ee6d5faf5f7920ba88b82c072864596f5b88af] ipmi: fix __init and
__exit attribute locations
git bisect bad 60ee6d5faf5f7920ba88b82c072864596f5b88af
# bad: [e6b46ee712b92db1cc2449cf4f65bc635366cad4] Merge branch
'drm-vmware-next' into drm-core-next
git bisect bad e6b46ee712b92db1cc2449cf4f65bc635366cad4
# good: [f7abfe8b281991c66406c42c1a6c6c9ee0daa0ff] drm/i915: Fix an
overlay regression from 7e7d76c
git bisect good f7abfe8b281991c66406c42c1a6c6c9ee0daa0ff
# bad: [9e0ae53404700f1e4ae1f33b0ff92948ae0e509d] drm/i915: Don't
overwrite the returned error-code
git bisect bad 9e0ae53404700f1e4ae1f33b0ff92948ae0e509d
# bad: [881f47b64723f4d697084533491a489e3e74b10f] drm/i915: add a new
BSD ring buffer for Sandybridge
git bisect bad 881f47b64723f4d697084533491a489e3e74b10f
# good: [f899fc64cda8569d0529452aafc0da31c042df2e] drm/i915: use GMBUS
to manage i2c links
git bisect good f899fc64cda8569d0529452aafc0da31c042df2e
# bad: [b84d5f0c22914d37d709add54c66e741c404fa56] drm/i915: Inline
i915_gem_ring_retire_request()
git bisect bad b84d5f0c22914d37d709add54c66e741c404fa56
# bad: [f49f0586191fe16140410db0a46d43bdc690d6af] drm/i915: Actually set
the reset bit in i965_reset.
git bisect bad f49f0586191fe16140410db0a46d43bdc690d6af
# bad: [219adae138513bae20b256f1946b9cb3b75ca05c] drm/i915: Cache LVDS
EDID
git bisect bad 219adae138513bae20b256f1946b9cb3b75ca05c
# good: [e9e5f8e8d373e72f5c39dafde1ce110fc7082118] Merge branch
'drm-intel-fixes' into HEAD
git bisect good e9e5f8e8d373e72f5c39dafde1ce110fc7082118

Jon.


