Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab0LRPaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:30:52 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:46383 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab0LRPav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:30:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BiZRbTgKDS2Som5V1xO0lzJm4/xSamADPytrjKfmxdBU21no44qE4oBWMxeYbnmb53
         aWehxK19Ga8107YjLM5ncmC9LY3RCboEX0DHiaJWop0dUI4xhPZpXMB/qoGR1ZL4RpHT
         FKvhhdWh4kI+LNCS/ZyZw8oJU7NLqU/XnIFDc=
Message-ID: <4D0CD3A8.7090609@kernel.org>
Date: Sat, 18 Dec 2010 16:30:48 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86: Use this_cpu_inc_return for nmi counter
References: <4D0CD337.4080407@kernel.org> <4D0CD37D.8020104@kernel.org>
In-Reply-To: <4D0CD37D.8020104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_inc_return() saves us a memory access there.

Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 arch/x86/kernel/apic/nmi.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index b387dce..37769cc 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -432,8 +432,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		 * Ayiee, looks like this CPU is stuck ...
 		 * wait a few IRQs (5 seconds) before doing the oops ...
 		 */
-		__this_cpu_inc(alert_counter);
-		if (__this_cpu_read(alert_counter) == 5 * nmi_hz)
+		if (__this_cpu_inc_return(alert_counter) == 5 * nmi_hz)
 			/*
 			 * die_nmi will return ONLY if NOTIFY_STOP happens..
 			 */
-- 
1.7.1

