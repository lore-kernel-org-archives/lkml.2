Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab1IZSn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab1IZSn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:43:56 -0400
Subject: [Fwd: Followup on ARM Minisummit at 2011 LPC]
From: Jon Masters <jcm@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-47bg/4jUmAL7nbaJBh1J"
Organization: Red Hat, Inc.
Date: Mon, 26 Sep 2011 14:41:13 -0400
Message-ID: <1317062473.6038.1788.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-47bg/4jUmAL7nbaJBh1J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Folks,

This is a courtesy forward because the conversation was (briefly) on
LKML before and I would like to make sure we are inclusive. If you have
comments and so on, please do not reply to this mail. Instead, please
sign up to the cross-distro list hosted by Linaro and send it there:

http://lists.linaro.org/mailman/listinfo/cross-distro

Thanks,

Jon.


--=-47bg/4jUmAL7nbaJBh1J
Content-Disposition: inline
Content-Description: Forwarded message - Followup on ARM Minisummit at 2011
 LPC
Content-Type: message/rfc822

Subject: Followup on ARM Minisummit at 2011 LPC
From: Jon Masters <jcm@redhat.com>
To: cross-distro <cross-distro@lists.linaro.org>
Cc: David Rusling <david.rusling@linaro.org>, Konstantinos Margaritis
 <konstantinos.margaritis@linaro.org>, Riku Voipio <riku.voipio@linaro.org>,
 Grant Likely <grant.likely@secretlab.ca>, Philippe Robin
 <Philippe.Robin@arm.com>, octo@linaro.org, Steve McIntyre
 <steve.mcintyre@linaro.org>, adconrad@ubuntu.com, andrew.stubbs@linaro.org,
 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat, Inc.
Date: Mon, 26 Sep 2011 14:37:40 -0400
Message-ID: <1317062260.6038.1779.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit

[ Please forward this to anyone else who should get a copy - and ask
them to signup to cross-distro@linaro because that's where we'll talk ]

Folks,

At the 2011 Linux Plumbers Conference in Santa Rosa, we held an ARM
minisummit to discuss a few cross-distribution issues surrounding the
"hard float" ABI for v7, and the ARM device and OS ecosystem in general.
This mail is intended to summarize the key actions from that meeting.

1). We discussed some of the different distributions (Debian, ChromeOS,
Fedora, MeeGo, Mozilla, Ubuntu, etc.). We all agree on a common notion
of what "hard float" means: it's the ARM AAPCS hardware floating point
stuff in section 6, with the -d16 register set of the VFPv3 being used.
Although there is some possibility to standardize v6, we decided we are
interested only in the present and future at this point (and that's v7).

Some use Thumb2, some don't, but interworking allows for that (we in
Fedora accidentally built a few packages with Thumb2 and will be undoing
that without users even noticing). NEON is similarly an optional feature
(supported by hwcaps) and not a required part of the core ABI. So it's
really just the ABI that we all care about, and we all agree on it.

For toolchain folks, this means we all agree on the following:

--with-float=hard --with-fpu=vfpv3-d16 --with-abi=aapcs-linux

(some of us may target different optimizations, etc. of course but that
is down to an application to decide whether it cares only about Cortex+)

2). We agreed on the importance of cross-distro binary compatibility. It
seems a number of distributions are excited by Debian's multi-arch
approach (as am I), but not all of us will be moving to it any time
soon. In the shorter term, if the runtime linker will have a special
path, we can work around that with symlinks, but it's a kludge. Our
preferred goal (from the meeting) is that everyone use this target:

arm-linux-gnueabihf

(Red Hat toolchains will include the vendor, but it is dropped by
autotools when actually generating the paths and comparisons). I will
advocate for Fedora ARM to switch to this target when possible, and in
the interim will try to ensure we can establish some symlinks for the
ability to run binaries compiled against Debian and Ubuntu on Fedora. I
don't know what our timeline will be for this, but it's not something
that's really landed everywhere yet. We at least agree on paths now!

3). We agree that it is a good idea to do LSB. Adam Conrad (Canonical)
and I agreed to represent community interests in driving this. We do
know that we'll be preferring OpenGL ES 2.0 over OpenGL (same namespace
within the library means one default choice is required). There will be
many other things :) We agree that the main benefit to pursuing LSB is
that it promotes the idea of working together and being compatible. It
may be that we don't have the same level of compliance on ARM, but some
level of conformance to some common standard(s) is a good start! :)

4). We decided that we should have a standing Cross Distro meeting at
Linaro Connect events, beginning with the next one in November. We will
also facilitate a "show and tell" for apps at Connect, and have an
opportunity to demo different distributions. We will add a specific
session at the next Connect to continue this discussion.

Finally, we agreed we should keep the conversation going. I apologize
for being a little tardy in sending this mail, but I want to kickstart
further discussion and get this ball rolling again. I'll ping Adam about
LSB (and thanks again to Jesse for the deep dive on GL). Meanwhile,
David can grab ownership of organizing the Cross Distro meeting at
Connect (I would like to assist). Anyone else got actions?

Jon.


--=-47bg/4jUmAL7nbaJBh1J--

