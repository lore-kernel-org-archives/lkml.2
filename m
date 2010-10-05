Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0JESam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:30:42 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:49392
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753789Ab0JESaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:30:39 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h43h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0L9TY2W-02-OA0-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 0/3] Basic support for LWP
Date: Tue, 5 Oct 2010 20:30:26 +0200
Message-ID: <1286303429-415145-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20101005182739.GE173@escobedo.osrc.amd.com>
References: <20101005182739.GE173@escobedo.osrc.amd.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LWP (Light-Weight Profiling) is a new profiling mechanism that allows
user mode processes to gather performance data about themselves with
very low overhead. The specification can be found here:
        http://developer.amd.com/cpu/LWP/Pages/default.aspx

These patches are against tip/master 531548b311024e1bec01bc412f5258e243a796b7.

This code adds basic support for LWP to the context switch code, which
is the minimum needed to use LWP. Support for other LWP features like
interrupts will be added later.


Hans Rosenfeld (3):
  Cleanup xsave/xrstor support.
  Allow saving of individual states in fpu_xsave().
  Save/restore LWP state in context switches.

 arch/x86/include/asm/i387.h       |   20 +++------
 arch/x86/include/asm/lwp.h        |   68 ++++++++++++++++++++++++++++
 arch/x86/include/asm/msr-index.h  |    1 +
 arch/x86/include/asm/processor.h  |   12 +++++
 arch/x86/include/asm/sigcontext.h |   12 +++++
 arch/x86/include/asm/xsave.h      |   90 +++++++++++++++---------------------
 arch/x86/kernel/process_32.c      |   13 +++++
 arch/x86/kernel/process_64.c      |   13 +++++
 arch/x86/kernel/traps.c           |    2 +-
 arch/x86/kernel/xsave.c           |    6 +-
 10 files changed, 167 insertions(+), 70 deletions(-)
 create mode 100644 arch/x86/include/asm/lwp.h


