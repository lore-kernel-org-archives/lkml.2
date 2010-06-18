Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0FRGEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:04:39 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62329 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0FRGEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:04:38 -0400
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
Date: Fri, 18 Jun 2010 09:04:14 +0300
Message-Id: <1276841055-13843-1-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.7.1.rc2
In-Reply-To: <20100602.143458.232754971.Hiroshi.DOYU@nokia.com>
References: <20100602.143458.232754971.Hiroshi.DOYU@nokia.com>
X-OriginalArrivalTime: 18 Jun 2010 06:04:29.0994 (UTC) FILETIME=[1D5C40A0:01CB0EAC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is another version of "kmemleak: Fix false positive", which
introduces another alias tree to keep track of all alias address of
each objects, based on the discussion(*1)

You can also find the previous one(*2), which uses special scan area
for alias addresses with a conversion function.

Compared with both methods, it seems that the current one takes a bit
longer to scan as below, tested with 512 elementes of (*3).

"kmemleak: Fix false positive with alias":
# time echo scan > /mnt/kmemleak
real    0m 8.40s
user    0m 0.00s
sys     0m 8.40s

"kmemleak: Fix false positive with special scan":
# time echo scan > /mnt/kmemleak 
real    0m 3.96s
user    0m 0.00s
sys     0m 3.96s

For our case(*4) to reduce false positives for the 2nd level IOMMU
pagetable allocation, the previous special scan  seems to be enough
lightweight, although there might be possiblity to improve alias
one and also I might misunderstand the original proposal of aliasing.

Any comment would be appreciated.

*1: http://lkml.org/lkml/2010/6/2/282
*2: kmemleak: Fix false positive with special scan
    http://lkml.org/lkml/2010/6/1/137
*3: kmemleak: Add special scan test case
    http://lkml.org/lkml/2010/6/1/134
*4: http://lkml.org/lkml/2010/6/1/136

Hiroshi DOYU (1):
  kmemleak: Fix false positive with alias

 include/linux/kmemleak.h |    4 +
 mm/kmemleak.c            |  198 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 168 insertions(+), 34 deletions(-)


