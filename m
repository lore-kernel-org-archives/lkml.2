Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1DNPig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:38:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29915 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1DNPif (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Apr 2011 11:38:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Fixes for P2M for save/restore functionality with 1-1 mapping for 2.6.40
Date: Thu, 14 Apr 2011 11:37:25 -0400
Message-Id: <1302795447-12685-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DA714F8.0079:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches are proposed for 2.6.40.

During the testing of the 1-1 mapping with PV guests (so PCI passthrough with
"Patches for PCI passthrough with modified E820:
http://lists.xensource.com/archives/html/xen-devel/2011-04/msg00574.html)
I discovered some bugs in the way the E820 setup code works and as well when
we create the P2M parallel data structures to contain the MFNs of the P2M pages
(so p2m_top_mfn_p and p2m_top_mfn).

The patches are located in git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/p2m-e820-pci.v2

The diffstat:

 arch/x86/xen/p2m.c   |   30 ++++++++++++++++++++++++++++--
 arch/x86/xen/setup.c |    2 +-
 2 files changed, 29 insertions(+), 3 deletions(-)

