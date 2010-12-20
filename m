Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab0LTUwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:52:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab0LTUwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:52:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [BISECTED] agp/intel: revert "Remove confusion of stolen entries not stolen memory"
Date: Mon, 20 Dec 2010 21:52:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
References: <201012201912.19051.arnd@arndb.de> <201012202047.08544.arnd@arndb.de> <0d30dc$kh3cm9@orsmga001.jf.intel.com>
In-Reply-To: <0d30dc$kh3cm9@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012202152.38863.arnd@arndb.de>
X-Provags-ID: V02:K0:uFXW9VP/GRDHm5VHZAaqHVUInp1ROLWRB6qRqr2ddvN
 CJy7OhUhRgOFZQdy/d2sckIdf7DZ6FTuV3VX8teQhFyXpM3d6M
 Y1yZt8UUZPJP1pgUksCF+Q9hbBOHRHPuxOVmhP1N7YDsvC+FAO
 t3nZuhsKphlyhpi54RUQC/b1mfDMLRTSr0h1cUMFpKqmN0I6Kq
 h33x7WE7MgTwJPXdY2YOA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 December 2010 20:52:07 Chris Wilson wrote:
> 
> Also, which modules do you have loaded when using VESA? i.e. is the
> i915.ko loaded, but in UMS mode (i915.modeset=0)?

This doesn't seem to matter, as far as I can tell, i915 can be loaded
or now.

I've seen the system crash once while loading i915 with
modeset=1 and my revert patch applied and backed it out.

After that, I could no longer even get i915 to do modesetting,
the ioremap in intel_opregion_setup now fails because reserve_memtype
decides that the opregion should be write-back when we ask for
an uncached mapping. That's probably an unrelated problem, but
I'm mentioning it anyway in case it's significant.

	Arnd
