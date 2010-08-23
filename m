Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab0HWXc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:32:28 -0400
Received: from tex.lwn.net ([70.33.254.29]:36257 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0HWXc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:32:27 -0400
Date: Mon, 23 Aug 2010 17:32:25 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Eric Anholt <eric@anholt.net>
Subject: Re: [now bisected] i915: 2.6.36-rc2 hoses my Intel display
Message-ID: <20100823173225.2bda6f78@bike.lwn.net>
In-Reply-To: <8u3s8d$jcc0rr@orsmga001.jf.intel.com>
References: <20100823110145.08eb72fd@bike.lwn.net>
 <20100823151708.6b242599@bike.lwn.net>
 <8u3s8d$jcc0rr@orsmga001.jf.intel.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 23:36:55 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> Taking the patch at face value, the cause should be a mistake in error
> handling. So the first step would be to identify which i2c_transfer()
> failed.

OK, I tried it, but neither warning triggers.

Don't know if it helps or not, but I tried booting with
drm.debug=0x05.  The result was truly vast amounts of stuff like this:

Aug 23 17:20:59 bike kernel: m:drm_ioctl], pid=2032, cmd=0x6458
nm:drm_ioctl], pid=2032, cmd=0x6458, nm:drm_ioctl], pid=2032, cmd=0x645
m:drm_ioctl], pid=2032, cmd=0x6458 m:drm_ioctl], pid=2032, cmd=0x6458,
m:drm_ioctl], pid=2032, cmd=0x6458, nm:drm_ioctl], pid=2032, cmd=0x6458
nm:drm_ioctl], pid=2032, cmd=0x6458 m:drm_ioctl], pid=2032, cmd=0x6458
nm:drm_ioctl], pid=2032, cmd=0x6458 nm:drm_ioctl], pid=2032, cmd=0x6458,
nm:drm_ioctl], pid=2032, cmd=0x6458, nm:drm_ioctl], pid=2032, cmd=0x6458
nm:drm_ioctl], pid=2032, cmd=0x6458 m:drm_ioctl], pid=2032, cmd=0x6458
nm:drm_ioctl], pid=2032, cmd=0x6458, nm:drm_ioctl], pid=2032, cmd=0x6458
m:drm_ioctl], pid=2032, cmd=0x6458 nm:drm_ioctl], pid=2032, cmd=0x6458,
nm:drm_ioctl], pid=2032, cmd=0x6458 m:drm_ioctl], pid=2032, cmd=0x6458
nm:drm_ioctl], pid=2032, cmd=0x6458 nm:drm_ioctl], pid=2032, cmd=0x6458,
nm:drm_ioctl], pid=2032, cmd=0x6458, m:drm_ioctl], pid=2032, cmd=0x6458,
nm:drm_ioctl], pid=2032, cmd=0x6458 nm:drm_ioctl], pid=2032, cmd=0x6458
nm:drm_ioctl], pid=2032, c

The above is one line from the system log; I took the liberty of wrapping
it for readability.  

jon
