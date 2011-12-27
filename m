Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1L0OP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:15:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53668 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab1L0OPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:15:54 -0500
Date: Tue, 27 Dec 2011 14:15:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 0/6] video: s3c-fb: Use runtime suspend while blanked
Message-ID: <20111227141550.GA3331@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series (the first two of which I posted the other day)
improves the runtime power management in the s3c-fb driver by moving it
to keeping the device runtime suspended when the screen is powered down
by userspace.  This saves a trivial amount of power in the framebuffer
controller and allows the SoC core code to enter system wide idle
states which offer much more substantial gains.

Currently it's only lightly tested but it certainly seems to the right
thing for me.

Mark Brown (6):
      video: s3c-fb: Make runtime PM functional again
      video: s3c-fb: Use s3c_fb_enable() to enable the framebuffer
      video: s3c-fb: Disable runtime PM in error paths from probe
      video: s3c-fb: Take a runtime PM reference when unblanked
      video: s3c-fb: Hold runtime PM references when touching registers
      video: s3c-fb: Don't keep device runtime active when open

 drivers/video/s3c-fb.c |  127 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 92 insertions(+), 35 deletions(-)

