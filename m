Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1HZSqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:46:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27976 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1HZSox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:44:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com,
        joe@perches.com
Subject: [PATCH v2] Xen PCI and Xen SWIOTLB patches for 3.2
Date: Fri, 26 Aug 2011 14:44:24 -0400
Message-Id: <1314384270-19850-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020204.4E57E99E.0009:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am proposing these six patches for 3.2.

Changelog [since v1: https://lkml.org/lkml/2011/8/24/435]
 - Make the string in pcifront be a continous line.
 - Implement some smarts in coherent alloc/dealloc so it does not
   always make a whole bunch hypercalls.

[v1 said]:
Nothing really exciting about them - just update some comments, fix
comments, and also make Xen SWIOTLB a bit smarter. Please take a look.

Patches are also available at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/pci.fixes


 drivers/pci/xen-pcifront.c |    5 +--
 drivers/xen/pci.c          |   11 ++++--
 drivers/xen/swiotlb-xen.c  |   70 +++++++++++++++++++++++++++++++++----------
 3 files changed, 62 insertions(+), 24 deletions(-)

Jan Beulich (1):
      xen/pci: make bus notifier handler return sane values

Konrad Rzeszutek Wilk (4):
      xen-pcifront: Update warning comment to use 'e820_host' option.
      xen-swiotlb: Retry up three times to allocate Xen-SWIOTLB
      xen-swiotlb: Fix wrong panic.
      xen-swiotlb: When doing coherent alloc/dealloc check before swizzling the MFNs.

Randy Dunlap (1):
      xen-swiotlb: fix printk and panic args

