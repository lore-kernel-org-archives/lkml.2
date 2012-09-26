Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2IZNkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:40:32 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:45522 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab2IZNkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:40:24 -0400
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2012 09:40:23 EDT
Message-Id: <50631F82020000A10000CB38@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 26 Sep 2012 15:30:10 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: 3.0.38: strange boot message: "Time: 165:165:165  Date:
 165/165/65" with Xen
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just discovered a strange "<6>[    0.123867] Time: 165:165:165  Date: 165/165/65" boot message in a Xen DomU VM for SLES11 SP2 on AMD Opteron (x86_64). The context is:

...
<6>[    0.080197] Initializing cgroup subsys net_cls
<6>[    0.080199] Initializing cgroup subsys blkio
<6>[    0.080204] Initializing cgroup subsys perf_event
<4>[    0.080245] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
<4>[    0.080245] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(
8)
<6>[    0.080293] SMP alternatives: switching to UP code
<6>[    0.103716] Brought up 1 CPUs
<6>[    0.103788] devtmpfs: initialized
<6>[    0.103977] print_constraints: dummy:
<6>[    0.123867] Time: 165:165:165  Date: 165/165/65
<6>[    0.123908] NET: Registered protocol family 16
<6>[    0.124081] SMP alternatives: switching to SMP code
<6>[    0.150019] Brought up 4 CPUs
<3>[    0.150019] PCI: Fatal: No config space access function found
<6>[    0.150019] PCI: setting up Xen PCI frontend stub
...

Maybe it's related to this hypervisor message (xm dmesg) in Xen Dom0 (but the RTC is at 70, right?):
(XEN) mm.c:833:d1 Non-privileged (1) attempt to map I/O space 000000f0
(XEN) mm.c:833:d3 Non-privileged (3) attempt to map I/O space 000000f0
(XEN) mm.c:833:d2 Non-privileged (2) attempt to map I/O space 000000f0
(XEN) mm.c:833:d1 Non-privileged (1) attempt to map I/O space 000000f0
(XEN) mm.c:833:d2 Non-privileged (2) attempt to map I/O space 000000f0

It's not a big issue, but maybe if the RTC cannot be read, it's better to skip rather tan outputting a wrong date/time.

Regards,
Ulrich


