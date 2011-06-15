Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1FOTVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:21:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63642 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab1FOTUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:20:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com
Subject: [PATCH] cleanup in Xen PCI (arch/x86/pci/xen.c) code for 3.1
Date: Wed, 15 Jun 2011 15:19:39 -0400
Message-Id: <1308165587-24902-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090201.4DF905E1.00E4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proposing these eight patches for 3.1. The goal of these patches is to:
 - clean up the Xen PCI glue code in xen.c to make it easier to maintain
 - squash some common code together if possible


I've tested it as PV PCI, PV Dom0, and lightly PVonHVM - I keep on getting
some really weird bootup problems with PVonHVM (it hangs on transitiong from
IDE to PV drivers with or without these patches) - so I will redo that test
shortly once I find out what is happening.

The patches are also available at
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git  stable/pci.cleanups

 arch/x86/include/asm/xen/pci.h |    5 +-
 arch/x86/pci/xen.c             |  370 ++++++++++++++++++----------------------
 drivers/xen/events.c           |    2 +-
 3 files changed, 170 insertions(+), 207 deletions(-)
