Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0JVLcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:32:39 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:44720 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab0JVLci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:32:38 -0400
Date: Fri, 22 Oct 2010 13:31:30 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Antonino Daplas <adaplas@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rivafb: dubious assignment
Message-ID: <20101022133130.4cb2cb96@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A duplicated assignment unconditionally changes max_gfsize to
GFIFO_SIZE.

It looks to me like this might not be intended, or is it?

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/video/riva/riva_hw.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/riva/riva_hw.c b/drivers/video/riva/riva_hw.c
index 78fdbf5..936abfa 100644
--- a/drivers/video/riva/riva_hw.c
+++ b/drivers/video/riva/riva_hw.c
@@ -263,7 +263,6 @@ static int nv3_iterate(nv3_fifo_info *res_info, nv3_sim_state * state, nv3_arb_i
     vmisses = 2;
     if (ainfo->gburst_size == 128) max_gfsize = GFIFO_SIZE_128;
     else  max_gfsize = GFIFO_SIZE;
-    max_gfsize = GFIFO_SIZE;
     while (1)
     {
         if (ainfo->vid_en)
-- 
1.7.2.2
