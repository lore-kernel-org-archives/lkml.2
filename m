Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0ENHRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:17:15 -0400
Received: from smtp.nokia.com ([192.100.122.233]:60650 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab0ENHRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:17:11 -0400
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [RFC][PATCH 0/2] kmemleak: Fix some false positives with special scan
Date: Fri, 14 May 2010 10:16:39 +0300
Message-Id: <1273821401-26578-1-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.7.1.rc1
X-OriginalArrivalTime: 14 May 2010 07:16:50.0277 (UTC) FILETIME=[6BE9A150:01CAF335]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I always get the false positives for the iommu 1st level page table
since it stores the pointer to the 2nd level page table, but it is
converted to a physical address with some attribute
bits. "kmemleak_ignore" can cover this problem, but will loose the
advantage of powerful kmemleak detection. So I experimentally
implement the APIs to register the special scan area with the address
conversion function. I'm not sure if this APIs make sense or not, but
it works for our OMAP IOMMU case now.

Any comment would be appreciated.

Hiroshi DOYU (2):
  kmemleak: Fix some false positives with special scan
  kmemleak: test: Add a special scan test case

 include/linux/kmemleak.h   |    4 ++
 mm/Makefile                |    2 +-
 mm/kmemleak-special-test.c |   89 ++++++++++++++++++++++++++++++++++++++++++++
 mm/kmemleak.c              |   83 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 174 insertions(+), 4 deletions(-)
 create mode 100644 mm/kmemleak-special-test.c

