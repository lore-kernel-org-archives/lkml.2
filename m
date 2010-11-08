Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0KHKSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:18:17 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:46781 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0KHKSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:18:16 -0500
Subject: [bisected] offset display bug in i915
From: Jon Masters <jonathan@jonmasters.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 05:18:32 -0500
Message-ID: <1289211512.3916.383.camel@constitution.bos.jonmasters.org>
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

Hi Chris,

The following patch that you recently committed breaks my ASUS Eee PC
1015PEM by causing the display to be offset by about 1 inch (a few
centimeters) when the mode is (re)set during boot. I previously posted
both photographs and video of the problem in another "PROBLEM" thread.

Here is the offending commit found through bisection:

219adae138513bae20b256f1946b9cb3b75ca05c is the first bad commit
commit 219adae138513bae20b256f1946b9cb3b75ca05c
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Sep 16 23:05:10 2010 +0100

    drm/i915: Cache LVDS EDID
    
    We assume that the panel is permenantly connected and that the EDID
    data is consistent from boot, so simply cache the whole EDID for the
    panel.
    
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

I'll look at the patch. Either the EDID is *not* consistent (in which
case, why are we not seeing other bugs like this?) or there is something
specific to this system or panel used.

Jon.


