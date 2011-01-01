Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab1AAPPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 10:15:13 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49664 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1AAPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 10:15:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=AJxYB1wwbfCKgZLqVTsAjpp8iHxsks2NUx+jcIyNrwntLypzNAr48qaqDCVGRadhFZ
         iVfYARgDTT6dOgNFA0/Ch4DB4DxyfWfC9DGSPSV/NeFnbZ18JkZubIvsJ2aCiN7J3s2Y
         zXAxPzUHK+3K5VsPA5Pvh6xu0WFTH8QknmrjM=
Message-ID: <4D1F44FA.8080905@gmail.com>
Date: Sat, 01 Jan 2011 16:15:06 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, galak@kernel.crashing.org
Subject: [PATCH] WARNING: add missing parentheses
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`!' has a higher precedence than `&' so parentheses are required.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/powerpc/sysdev/fsl_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 818f7c6..29b497a 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -715,7 +715,7 @@ u64 fsl_pci_immrbar_base(struct pci_controller *hose)
 		in = pcie->cfg_type0 + PEX_RC_INWIN_BASE;
 		for (i = 0; i < 4; i++) {
 			/* not enabled, skip */
-			if (!in_le32(&in[i].ar) & PEX_RCIWARn_EN)
+			if (!(in_le32(&in[i].ar) & PEX_RCIWARn_EN))
 				 continue;
 
 			if (get_immrbase() == in_le32(&in[i].tar))
