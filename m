Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab1KCDT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:19:26 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:9778 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab1KCDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:19:21 -0400
Message-Id: <201111030319.pA33JK3I005869@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 2 Nov 2011 22:23:41 -0400
Subject: [PATCH] arch/tile: avoid exporting a symbol no longer used by gcc
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 03 Nov 2011 03:19:20.0561 (UTC) FILETIME=[60A90610:01CC99D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An earlier Tilera compiler generated calls to an "__ll_mul"
function for long long multiplication.  Our libgcc supported that
as an alias for the normal __muldi3 routine, so we made it available
to kernel modules as well.  However, for a while now the compiler
has internally been generating only the standard __muldi3 symbol,
and the version we are giving back to the community does not have
the __ll_mul alias, so we are removing it from the kernel too.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/exports.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index 49284fa..a87d2a8 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -79,8 +79,6 @@ EXPORT_SYMBOL(__umoddi3);
 int64_t __moddi3(int64_t dividend, int64_t divisor);
 EXPORT_SYMBOL(__moddi3);
 #ifndef __tilegx__
-uint64_t __ll_mul(uint64_t n0, uint64_t n1);
-EXPORT_SYMBOL(__ll_mul);
 int64_t __muldi3(int64_t, int64_t);
 EXPORT_SYMBOL(__muldi3);
 uint64_t __lshrdi3(uint64_t, unsigned int);
-- 
1.6.5.2

