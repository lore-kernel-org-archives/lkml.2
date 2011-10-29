Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab1J2NqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 09:46:00 -0400
Received: from re04.intra2net.com ([82.165.46.26]:49923 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721Ab1J2Np7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 09:45:59 -0400
Message-ID: <4EAC0394.5000807@intra2net.com>
Date: Sat, 29 Oct 2011 15:45:56 +0200
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix off-by-two in arcs_cmdline buffer size check
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cause is a misplaced bracket.

The code

    strlen(buf+1)

will be two bytes less than

    strlen(buf)+1

The +1 is in this code to reserve space for an additional space character.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 arch/mips/pmc-sierra/yosemite/prom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/pmc-sierra/yosemite/prom.c b/arch/mips/pmc-sierra/yosemite/prom.c
index cf4c868..a6d5eb3 100644
--- a/arch/mips/pmc-sierra/yosemite/prom.c
+++ b/arch/mips/pmc-sierra/yosemite/prom.c
@@ -102,7 +102,7 @@ void __init prom_init(void)
 
 	/* Get the boot parameters */
 	for (i = 1; i < argc; i++) {
-		if (strlen(arcs_cmdline) + strlen(arg[i] + 1) >=
+		if (strlen(arcs_cmdline) + strlen(arg[i]) + 1 >=
 		    sizeof(arcs_cmdline))
 			break;
 
-- 
1.7.6.4

