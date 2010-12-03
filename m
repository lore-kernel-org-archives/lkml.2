Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab0LCGwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 01:52:19 -0500
Received: from relay2.sgi.com ([192.48.179.30]:36316 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754755Ab0LCGwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 01:52:19 -0500
Date: Fri, 3 Dec 2010 00:52:12 -0600
From: Robin Holt <holt@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Adrian Bunk <bunk@kernel.org>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jack Steiner <steiner@sgi.com>
Subject: Do we need to call calibrate_delay() for all cores/hyperthreads on
 a socket?
Message-ID: <20101203065212.GQ6858@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I do not know all the different combinations of sockets, cores, and
hyperthreads out there, but it seems like all cores and their hyperthreads
on a socket should compute the same value for their calculate_delay()
function.

When booting a 4096 cpu system without specifying lpj on the command line,
we spend approximately 0.1 seconds per core/hyperthread calculating the
lpj value for that cpu.

If we were to, on the other hand, only calculate the delay value for the
first core on a socket, we would reduce the time spent booting a 4096 cpu
(256 sockets, 8 cores per socket hyperthreaded) down from nearly seven
minutes to approx 25 seconds.  This seems like a very safe optimization,
but I repeat that I do not know all the different potential combinations
of socket, core, hyperthread out that.  Please note these are just rough
approximations taken from memory.  I am doing a couple of test boots
now without and with lpj= specified on the command line to get a more
accurate approximation.

Thanks,
Robin Holt
