Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1GJSze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:55:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43633 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab1GJSzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:55:33 -0400
MIME-Version: 1.0
Date: Sun, 10 Jul 2011 20:55:32 +0200
X-Google-Sender-Auth: V2uYXJlt80qN-9pXK8IEtElDXBo
Message-ID: <CABkP77e6vLmLxk3wCP39GJ7+yKnJZFc7BPUZ1OkdA8d7KkBCiw@mail.gmail.com>
Subject: [PATCH] powerpc/85xx: fix mpic configuration in CAMP mode
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Poonam Aggrwal <poonam.aggrwal@freescale.com>,
        Fabio Baltieri <fabio.baltieri@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the string to check for CAMP mode boot on MPC85xx (eg. P2020) to match
the one in the corresponding dts files (p2020rdb_camp_core{0,1}.dts).

Without this fix the mpic is configured as in the SMP boot mode, which causes
the first core to report a protected source interrupt error for devices
of the other core and lock up.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
---
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index 088f30b..a1e5e70 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -58,7 +58,7 @@ void __init mpc85xx_rdb_pic_init(void)
 		return;
 	}

-	if (of_flat_dt_is_compatible(root, "fsl,85XXRDB-CAMP")) {
+	if (of_flat_dt_is_compatible(root, "fsl,MPC85XXRDB-CAMP")) {
 		mpic = mpic_alloc(np, r.start,
 			MPIC_PRIMARY |
 			MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
-- 
1.7.5.1
