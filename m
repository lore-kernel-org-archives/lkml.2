Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab1I2TxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:53:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36349 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab1I2TxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:53:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com
Subject: [PATCH] Xen bug-fixes for 3.2 (v1)
Date: Thu, 29 Sep 2011 15:52:42 -0400
Message-Id: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E84CC9D.0085:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of them were discovered by running Dan's static analyzer
(git://repo.or.cz/smatch.git). Some of them look/sound familiar
which probably means at some point somebody emailed me it and
I forgot it - if that is the case, please point me to it so I can
use that instead of these.

Please review.

Konrad Rzeszutek Wilk (9):
      xen/pciback: Do not dereference psdev during printk when it is NULL.
      xen/pciback: Return proper error code from sscanf.
      xen/pciback: Check if the device is found instead of blindly assuming so.
      xen/events: BUG() when we can't allocate our event->irq array.
      xen/events: Don't check the info for NULL as it is already done.
      xen/irq: If we fail during msi_capability_init return proper error code.
      xen/xenbus: Check before dereferencing it.
      xen/enlighten: Fix compile warnings.
      xen/p2m/debugfs: Fix potential pointer exception.

 arch/x86/pci/xen.c                        |   10 +++++++---
 arch/x86/xen/enlighten.c                  |    2 +-
 arch/x86/xen/p2m.c                        |    4 ++--
 drivers/xen/events.c                      |   11 +++++++----
 drivers/xen/xen-pciback/pci_stub.c        |   12 ++++++++----
 drivers/xen/xenbus/xenbus_probe_backend.c |    3 ++-
 6 files changed, 27 insertions(+), 15 deletions(-)
