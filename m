Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab0HWXiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:38:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:55329 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab0HWXiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:38:16 -0400
Message-Id: <8u3s94$gak083@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,260,1280732400"; 
   d="scan'208";a="548012291"
Date: Tue, 24 Aug 2010 00:37:52 +0100
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [now bisected] i915: 2.6.36-rc2 hoses my Intel display
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Eric Anholt <eric@anholt.net>
References: <20100823110145.08eb72fd@bike.lwn.net> <20100823151708.6b242599@bike.lwn.net> <8u3s8d$jcc0rr@orsmga001.jf.intel.com> <20100823173225.2bda6f78@bike.lwn.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100823173225.2bda6f78@bike.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 17:32:25 -0600, Jonathan Corbet <corbet@lwn.net> wrote:
> On Mon, 23 Aug 2010 23:36:55 +0100
> Chris Wilson <chris@chris-wilson.co.uk> wrote:
> 
> > Taking the patch at face value, the cause should be a mistake in error
> > handling. So the first step would be to identify which i2c_transfer()
> > failed.
> 
> OK, I tried it, but neither warning triggers.

Sigh, that sounds like I screwed the patch up instead.
Thanks.

> Don't know if it helps or not, but I tried booting with
> drm.debug=0x05.  The result was truly vast amounts of stuff like this:
> 
> Aug 23 17:20:59 bike kernel: m:drm_ioctl], pid=2032, cmd=0x6458
> nm:drm_ioctl], pid=2032, cmd=0x6458, nm:drm_ioctl], pid=2032, cmd=0x645
[snip]
> 
> The above is one line from the system log; I took the liberty of wrapping
> it for readability.  

Hmm, probably bailing out of the ioctl before hitting the newline.
drm.debug=0x4 should print the right information for this bug.

-- 
Chris Wilson, Intel Open Source Technology Centre
