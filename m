Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab2GCWhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:37:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50577 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756267Ab2GCWhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:37:11 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <j-keerthy@ti.com>, <grant.likely@secretlab.ca>, <b-cousson@ti.com>,
        <kbaidarov@dev.rtsoft.ru>, Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 0/4] staging: adding OMAP bandgap driver
Date: Wed, 4 Jul 2012 01:37:06 +0300
Message-ID: <1341355030-20800-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.5.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

This is a set of patches which contains a temperature sensor driver
for OMAP platform and a minimal support for the generic thermal framework
(CONFIG_THERMAL).

It was originally written for TI's android development
tree, where it has its own thermal framework.

I have ripped it off from that tree and add basic support on the driver
to use the generic thermal framework (CONFIG_THERMAL). Apart from
that, the driver have already gone through some rewrites and redesigns.

This device resides inside the system control module of OMAP and the
original driver had a MFD design. Now with the rewrites, it got
only DT probing support and with that it has its own io area,
and it works pretty much independent.

FYI, the generic thermal framework is also under its own
improvements cycles, and the support I've written on this driver
I am sending, depends partially on it. It relies on the generic
CPU cooling device (CONFIG_CPU_COOLING). But the driver won't
compile that part of the code, unless the config entry is present.
So, the way it is now, it is compilable, but the output module
will not have thermal framework exposure (/sys/class/thermal).

The driver is under work, but it can already probe on OMAPs 4430,
4460 (potentially on 4470, but this is untested) and 5430.

So, I decided to send it to staging for maturation, instead
of maturating it out of the tree.

Let me know if it makes sense to keep it under staging.
Otherwise I can go through its maturation out of tree and
send it for merge under drivers/thermal/ (Len B.)

These patches are based on linux-next/master. And you can also
fetch them here:

git@gitorious.org:thermal-framework/thermal-framework.git thermal_work/omap/bandgap_staging

All best,


Eduardo Valentin (4):
  staging: OMAP4+: thermal: introduce bandgap temperature sensor
  staging: omap-thermal: common code to expose driver to thermal
    framework
  staging: omap-thermal: add OMAP4 data structures
  staging: omap-thermal: add OMAP5 data structures

 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/omap-thermal/Kconfig               |   45 +
 drivers/staging/omap-thermal/Makefile              |    5 +
 drivers/staging/omap-thermal/TODO                  |   27 +
 drivers/staging/omap-thermal/omap-bandgap.c        | 1186 ++++++++++++++++++++
 drivers/staging/omap-thermal/omap-bandgap.h        |  441 ++++++++
 drivers/staging/omap-thermal/omap-thermal-common.c |  397 +++++++
 drivers/staging/omap-thermal/omap-thermal.h        |  108 ++
 drivers/staging/omap-thermal/omap4-thermal.c       |  259 +++++
 drivers/staging/omap-thermal/omap5-thermal.c       |  297 +++++
 drivers/staging/omap-thermal/omap_bandgap.txt      |   30 +
 12 files changed, 2798 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/omap-thermal/Kconfig
 create mode 100644 drivers/staging/omap-thermal/Makefile
 create mode 100644 drivers/staging/omap-thermal/TODO
 create mode 100644 drivers/staging/omap-thermal/omap-bandgap.c
 create mode 100644 drivers/staging/omap-thermal/omap-bandgap.h
 create mode 100644 drivers/staging/omap-thermal/omap-thermal-common.c
 create mode 100644 drivers/staging/omap-thermal/omap-thermal.h
 create mode 100644 drivers/staging/omap-thermal/omap4-thermal.c
 create mode 100644 drivers/staging/omap-thermal/omap5-thermal.c
 create mode 100644 drivers/staging/omap-thermal/omap_bandgap.txt

-- 
1.7.7.1.488.ge8e1c

