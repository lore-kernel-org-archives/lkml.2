Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab1JMOkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:40:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54180 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab1JMOkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:40:18 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=-IwIJ7haf00A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=c6D-3vmD6x4PbIFNm9IA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318516816.12224.12.camel@gandalf.stny.rr.com>
Subject: [PATCH] m32r: Allow use of atomic64
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-m32r@ml.linux-m32r.org
Cc: Hirokazu Takata <takata@linux-m32r.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 13 Oct 2011 10:40:16 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atomic64 is now a valid type in Linux. Archs that do not have their own
version of atomic64 operators are to use the generic operations.

The m32r architecture needs to define GENERIC_ATOMIC64.

Reported-by: Ingo Molnar <mingo@elte.hu>
Link: http://lkml.kernel.org/r/20111013085936.GA13046@elte.hu
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index b92b944..6c4e9aa 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select GENERIC_ATOMIC64
 
 config SBUS
 	bool


