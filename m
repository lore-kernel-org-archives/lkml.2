Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371Ab2AMWYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:24:34 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37585 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab2AMWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:24:29 -0500
MIME-Version: 1.0
From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 13 Jan 2012 17:24:07 -0500
Message-ID: <CAOPLpQc_TfvtfJ0NL+4fsi2r_eW+4qWX+WbXrZ9BjGn44nAmBw@mail.gmail.com>
Subject: Typo transferred from Intel manual
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch/x86/lib/x86-opcode-map.txt file contains the line

af: SCAS/W/D/Q rAX,Xv


This is what the Intel manuals show, but it's not correct.  The 'X' stands for

Memory addressed by the DS:rSI register pair (for example, MOVS, CMPS,
OUTS, or LODS).


On the other hand 'Y' means (also see the ae byte entry for SCASB):

Memory addressed by the ES:rDI register pair (for example, MOVS, CMPS,
INS, STOS, or SCAS).


Hence the following patch should be applied:



Signed-off-by: Ulrich Drepper <drepper@gmail.com>

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 5b83c51..c292885 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -219,7 +219,7 @@ ab: STOS/W/D/Q Yv,rAX
 ac: LODS/B AL,Xb
 ad: LODS/W/D/Q rAX,Xv
 ae: SCAS/B AL,Yb
-af: SCAS/W/D/Q rAX,Xv
+af: SCAS/W/D/Q rAX,Yv
 # 0xb0 - 0xbf
 b0: MOV AL/R8L,Ib
 b1: MOV CL/R9L,Ib
