Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab0JVSYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62638 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0JVSYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=k++H1fmmf7u1NpYr2LQqZD1KmVL5fbsF/XEyCnD/MsW+BK2CkXIIkz8SEGH3YEEdzZ
         odd2uH7K2oX33WQY65RFXNiQSDwgJYxYVitawk/TF6ZwloMLk/QxvEnaKZSJB/gb9vW2
         bFHfpJrvMSIBQHh6081We6AUM0PxET7Q/LbNo=
Message-ID: <4CC1D6BF.90204@gmail.com>
Date: Fri, 22 Oct 2010 20:23:59 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Li Yi <yi.li@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [RFC][PATCH 1/8] Removal of dead code from arch/blackfin/kernel/traps.c
References: <4CC1D2D5.9050009@gmail.com>
In-Reply-To: <4CC1D2D5.9050009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit de6f2dfdf5c3dcd0e5eeaf9ab690a5d1081c065c
Author: N.P.S <napohybelskurwysynom2010@gmail.com>
Date:   Fri Oct 22 00:01:41 2010 +0200

    Removal of dead code from
    arch/blackfin/kernel/traps.c
    
    Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
    CC: Li Yi <yi.li@analog.com>
    CC: <uclinux-dist-devel@blackfin.uclinux.org>
    CC: <linux-kernel@vger.kernel.org>

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 59c1df7..b20eca8 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -280,17 +280,7 @@ asmlinkage notrace void trap_c(struct pt_regs *fp)
 			goto traps_done;
 		else
 			break;
-#ifdef CONFIG_BF535
-	/* 0x29 - Instruction fetch access error (535 only) */
-	case VEC_ISTRU_VL:      /* ADSP-BF535 only (MH) */
-		info.si_code = BUS_OPFETCH;
-		sig = SIGBUS;
-		strerror = KERN_NOTICE "BF535: VEC_ISTRU_VL\n";
-		CHK_DEBUGGER_TRAP_MAYBE();
-		break;
-#else
 	/* 0x29 - Reserved, Caught by default */
-#endif
 	/* 0x2A - Instruction fetch misaligned, handled here */
 	case VEC_MISALI_I:
 		info.si_code = BUS_ADRALN;
