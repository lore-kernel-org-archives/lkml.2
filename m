Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0CUVZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 17:25:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59680 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab0CUVZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 17:25:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: dri-devel@lists.sourceforge.net
Subject: Resume problem with radeon+KMS (2.6.34-rc2 and before)
Date: Sun, 21 Mar 2010 22:28:13 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       =?iso-8859-2?q?J=E9r=F4me_Glisse?= <glisse@freedesktop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003212228.13923.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some time ago I reported a problem with resuming from suspend to RAM on
HP nx6325 with radeon+KMS.

The problem was that the first resume always failed if the suspend was started
from under X.  Moreover, the resume went correctly until the last switch from
the framebuffer console (which was now controlled by the radeon driver as
well) to X that made the box hang hard.

However, if the first resume was started from the (radeon-controlled)
framebuffer console, the subsequent resume succeeded and all of the next
attempts to suspend/resume succeeded, _regardless_ of the way the suspend was
started.

At that time Dave thought it might be a problem with the nx6325's graphics
adapter that apparently was a crappy one, but today I found that _exactly_ the
same behavior was observable on Acer Ferrari One, which was quite different,
hardware-wise, from the old HP box.  For this reason I think the problem is
related to the driver itself rather than to the hardware or firmware.

The problem is reproducible on both machines with the latest git kernel
and the user space radeon_drv.so from openSUSE 11.2 (it says
module version = 6.12.4 in the X log).  The kernel and user space are 64-bit
on both machines.  [For completness, the Acer box suspends and resumes
correctly with radeon.modeset=0 and "s2ram -f -p -m".]

Should I try a newer user space X driver?  Or may the problem be related to
the 64-bitness somehow?

Rafael
