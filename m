Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab0JVSZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43781 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758795Ab0JVSZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=xLs1BcejMidhNJmPZoQBkH4MLuGa1lwQVyTDaZ15UP1W6YoUcpO0ew5JiJy/bcKpvx
         r1WnJgtstaJtNcNxULUkMshGcwVXP9MfhA3eGHnti9LpwYhqUz6ihtdJFFYlAl9QrlFU
         c7nB+mrwAkmFZ24CHpp0Emojgf+ba8lbX6/Kc=
Message-ID: <4CC1D700.7030007@gmail.com>
Date: Fri, 22 Oct 2010 20:25:04 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [RFC][PATCH 7/8] Removal of dead code from arch/powerpc/mm/tlb_low_64e.S
 and arch/powerpc/include/asm/exception-64e.h
References: <4CC1D2D5.9050009@gmail.com>
In-Reply-To: <4CC1D2D5.9050009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bca5655fdfd3ad0a4891914bd88b28f78e5cec16
Author: N.P.S <napohybelskurwysynom2010@gmail.com>
Date:   Thu Oct 21 23:26:48 2010 +0200

    Removal of dead code from
    arch/powerpc/mm/tlb_low_64e.S
    arch/powerpc/include/asm/exception-64e.h
    
    Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
    CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    CC: Paul Mackerras <paulus@samba.org>
    CC: <linuxppc-dev@lists.ozlabs.org>
    CC: <linux-kernel@vger.kernel.org>

diff --git a/arch/powerpc/include/asm/exception-64e.h b/arch/powerpc/include/asm/exception-64e.h
index 6d53f31..db74814 100644
--- a/arch/powerpc/include/asm/exception-64e.h
+++ b/arch/powerpc/include/asm/exception-64e.h
@@ -65,14 +65,7 @@
 #define EX_TLB_MMUCR0	(12 * 8) /* Level 0 */
 #define EX_TLB_MAS1	(12 * 8) /* Level 0 */
 #define EX_TLB_MAS2	(13 * 8) /* Level 0 */
-#ifdef CONFIG_BOOK3E_MMU_TLB_STATS
-#define EX_TLB_R8	(14 * 8)
-#define EX_TLB_R9	(15 * 8)
-#define EX_TLB_LR	(16 * 8)
-#define EX_TLB_SIZE	(17 * 8)
-#else
 #define EX_TLB_SIZE	(14 * 8)
-#endif
 
 #define	START_EXCEPTION(label)						\
 	.globl exc_##label##_book3e;					\
@@ -157,36 +150,6 @@ exc_##label##_book3e:
 	addi	r11,r13,PACA_EXTLB;					    \
 	TLB_MISS_RESTORE(r11)
 
-#ifdef CONFIG_BOOK3E_MMU_TLB_STATS
-#define TLB_MISS_PROLOG_STATS						    \
-	mflr	r10;							    \
-	std	r8,EX_TLB_R8(r12);					    \
-	std	r9,EX_TLB_R9(r12);					    \
-	std	r10,EX_TLB_LR(r12);
-#define TLB_MISS_RESTORE_STATS					            \
-	ld	r16,EX_TLB_LR(r12);					    \
-	ld	r9,EX_TLB_R9(r12);					    \
-	ld	r8,EX_TLB_R8(r12);					    \
-	mtlr	r16;
-#define TLB_MISS_STATS_D(name)						    \
-	addi	r9,r13,MMSTAT_DSTATS+name;				    \
-	bl	.tlb_stat_inc;
-#define TLB_MISS_STATS_I(name)						    \
-	addi	r9,r13,MMSTAT_ISTATS+name;				    \
-	bl	.tlb_stat_inc;
-#define TLB_MISS_STATS_X(name)						    \
-	ld	r8,PACA_EXTLB+EX_TLB_ESR(r13);				    \
-	cmpdi	cr2,r8,-1;						    \
-	beq	cr2,61f;						    \
-	addi	r9,r13,MMSTAT_DSTATS+name;				    \
-	b	62f;							    \
-61:	addi	r9,r13,MMSTAT_ISTATS+name;				    \
-62:	bl	.tlb_stat_inc;
-#define TLB_MISS_STATS_SAVE_INFO					    \
-	std	r14,EX_TLB_ESR(r12);	/* save ESR */			    \
-
-
-#else
 #define TLB_MISS_PROLOG_STATS
 #define TLB_MISS_RESTORE_STATS
 #define TLB_MISS_STATS_D(name)
@@ -194,7 +157,6 @@ exc_##label##_book3e:
 #define TLB_MISS_STATS_X(name)
 #define TLB_MISS_STATS_Y(name)
 #define TLB_MISS_STATS_SAVE_INFO
-#endif
 
 #define SET_IVOR(vector_number, vector_offset)	\
 	li	r3,vector_offset@l; 		\
diff --git a/arch/powerpc/mm/tlb_low_64e.S b/arch/powerpc/mm/tlb_low_64e.S
index 8b04c54..fc87217 100644
--- a/arch/powerpc/mm/tlb_low_64e.S
+++ b/arch/powerpc/mm/tlb_low_64e.S
@@ -757,13 +757,3 @@ tlb_load_linear_fault:
 	b	exc_data_storage_book3e
 1:	TLB_MISS_EPILOG_ERROR_SPECIAL
 	b	exc_instruction_storage_book3e
-
-
-#ifdef CONFIG_BOOK3E_MMU_TLB_STATS
-.tlb_stat_inc:
-1:	ldarx	r8,0,r9
-	addi	r8,r8,1
-	stdcx.	r8,0,r9
-	bne-	1b
-	blr
-#endif
