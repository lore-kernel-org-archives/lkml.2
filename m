Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab0JEMuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 08:50:25 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:44595 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0JEMuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 08:50:24 -0400
X-IronPort-AV: E=Sophos;i="4.57,284,1283731200"; 
   d="scan'208";a="2194202"
Date: Tue, 5 Oct 2010 13:50:32 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0/2] Xen PV on HVM bug fixes for 2.6.36 rc6
Message-ID: <alpine.DEB.2.00.1010051243300.2440@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this series is a collection of two serious bug fixes for Linux 2.6.36 rc6:


Stefano Stabellini (2):
      xen: do not set xenstored_ready before xenbus_probe on hvm
      xen: do not initialize PV timers on HVM if !xen_have_vector_callback

 arch/x86/xen/time.c               |    5 +++--
 drivers/xen/xenbus/xenbus_probe.c |    9 ++++++---
 2 files changed, 9 insertions(+), 5 deletions(-)


The first patch fixes a bug in the shutdown_event watcher
registration that causes "xm shutdown" not to work properly for PV on
HVM guests: register_xenstore_notifier should be able to guarantee that
the caller gets notified when xenstore is ready no matter if xenstore is
already up. The right way of fixing register_xenstore_notifier's bad
behavior is to set xenstored_ready at the right time for PV on HVM
guests too, instead of failing to notify callers when xenstore is
already up.
The second patch fixes an hang at boot that happens when Xen doesn't
support vector callbacks and the guest has multiple vcpus. Considering
that we cannot get PV timers working on cpus > 0 without vector
callbacks, it is just safer to disable completely PV timers in that
case.

I realize it might be too late for rc6, if that is case then just let me
know and I'll resubmit the series during the next merge window.

A git branch with these two fixes on top of 2.6.36 rc6 is available
here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git v2.6.36-rc6-urgent-fixes

Cheers,

Stefano
