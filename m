Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1BCDyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 22:54:22 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56858 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1BCDyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 22:54:21 -0500
Date: Wed, 2 Feb 2011 19:54:17 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC] [PATCH 0/19] mfd sharing support
Message-ID: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset sets up support for sharing of MFD cells across multiple
drivers.  This is something we'd like for OLPC power management, but
plenty of other drivers do similar things.  Every driver seems to have
its own way of accomplishing the task, and rather than go that route,
I'd rather have a common way to do it in mfd-core.

The parts of this patch series are somewhat separate, so that one
can pick and choose.  The first group (patches 1-16) makes mfd
cells always available (and adjusts any drivers that are using
platform_data to use driver_data instead) to mfd clients.  The second
group (patch 17) adds optional wrappers for the mfd_cell's
enable/disable hooks to handle reference counting.


The third group (patch 18) adds support for shared platform_devices,
and the last one (patch 19) adapts the cs5535-mfd/olpc-xo1 drivers to
make use of the sharing code.  These last two groups still need a bit
of work, but I was hoping to get feedback on the whole set.
