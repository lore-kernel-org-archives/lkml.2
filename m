Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1GSVOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:14:53 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:48131 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159Ab1GSVOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:14:51 -0400
Date: Tue, 19 Jul 2011 17:14:38 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Subject: kmemleak fails to report detected leaks after allocation failure
Message-ID: <20110719211438.GA21588@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just ran into a somewhat amusing issue with kmemleak.  After running
for a while (10 days), and detecting about 100 "suspected memory leaks",
kmemleak ultimately reported:

  kmemleak: Cannot allocate a kmemleak_object structure
  kmemleak: Automatic memory scanning thread ended
  kmemleak: Kernel memory leak detector disabled

OK, so something failed and kmemleak apparently can't recover from
this.  However, at this point, it appears that kmemleak has *also*
lost the ability to report the earlier leaks that it actually
detected.

  cat: /sys/kernel/debug/kmemleak: Device or resource busy

It seems to me that kmemleak shouldn't lose the ability to report leaks
that it already detected after it disables itself due to an issue that
was potentially caused by the very leaks that it managed to detect
(unlikely in this instance, but still...).

This was on a 2.6.39.2 kernel on x86_64.

I imagine that such a failure is unlikely to repeat itself, but I
figured I'd throw it out there.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
