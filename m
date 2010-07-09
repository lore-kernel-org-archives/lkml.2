Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab0GIApM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:45:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54814 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab0GIApK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:45:10 -0400
Date: Thu, 8 Jul 2010 17:45:05 -0700
From: Kees Cook <kees@outflux.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Chris Wilson <"email addresshidden"@ogre.sisk.pl>
Subject: Re: [Bug #16294] [Q35 bisected] hang at init of i915 driver
Message-ID: <20100709004505.GU828@outflux.net>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
 <TXb9XdQzJoD.A.uoB.WMmNMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TXb9XdQzJoD.A.uoB.WMmNMB@chimera>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Fri, Jul 09, 2010 at 01:41:39AM +0200, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).

Yup, this is still a regression.  The fix is trivial (see below).

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16294
> Subject		: [Q35 bisected] hang at init of i915 driver
> Submitter	: Kees Cook <kees@outflux.net>
> Date		: 2010-06-25 18:20 (14 days old)
> First-Bad-Commit: http://git.kernel.org/linus/f1befe71fa7a79ab733011b045639d8d809924ad

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 9344216..0d9007d 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1229,6 +1229,7 @@ static int intel_i915_get_gtt_size(void)
 				(gmch_ctrl & G33_PGETBL_SIZE_MASK));
 			size = 512;
 		}
+		size = 1024;
 	} else {
 		/* On previous hardware, the GTT size was just what was
 		 * required to map the aperture.

-- 
Kees Cook                                            @outflux.net
