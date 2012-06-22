Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480Ab2FVQNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:13:36 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:55745 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2FVQNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:13:35 -0400
X-IronPort-AV: E=Sophos;i="4.77,459,1336348800"; 
   d="scan'208";a="13174817"
Date: Fri, 22 Jun 2012 17:13:12 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, Tim Deegan <tim@xen.org>
Subject: [PATCH WIP 0/6] xen/arm: PV console support
Message-ID: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series fixes few Xen on ARM bugs as well as one generic Xen PV
on HVM bug (I'll send out that patch separately).
It also implements a better way to initialize Xen on ARM and find out
whether we are a privileged or an unprivileged guest.

With this patch series applied to Linux and the corresponding Xen patch series
applied to Xen, I can boot a Linux guest up to userspace and connect to
it using a PV console in dom0.

The patch series is based on Ian's Linux for Xen on ARM tree
(git://xenbits.xen.org/people/ianc/linux-2.6.git devel/arm-hacks).


Stefano Stabellini (6):
      xen/arm: fix the shared_info and vcpu_info structs
      xen/arm: Introduce xen_guest_init
      xen/arm: get privilege status
      xen/arm: implement hvm_op
      xen: fix unmask_evtchn for HVM guests
      xen/arm: enable evtchn irqs

 arch/arm/include/asm/xen/hypercall.h |    2 +-
 arch/arm/include/asm/xen/interface.h |   15 +++------------
 arch/arm/xen/enlighten.c             |   21 ++++++++++++++++-----
 arch/x86/xen/enlighten.c             |    8 ++++++++
 drivers/tty/hvc/hvc_xen.c            |    3 +++
 drivers/xen/events.c                 |   10 ++++++++--
 include/xen/interface/features.h     |    3 +++
 include/xen/xen.h                    |    2 ++
 8 files changed, 44 insertions(+), 20 deletions(-)

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git xenarmv7-2

Cheers,

Stefano
