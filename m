Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848Ab0LNRtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:49:05 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:43637 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751421Ab0LNRtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:49:02 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 98iqDzcVM1lEA4rz0Gm_Vq4p13dw.9EXkQRWe05JrTeo3V1
 dnwm3FD1JW2YUXAxqs6ejuhOiLrsqvs2xRAiwWdURBXpRVbQqy17wDkAqr5f
 dlT4Ow6TqXcdGSEts2EHeo4ck.sPQv82Ex1Jnz0F5XB5czxXN1MzN76scqEE
 yLcPmO87G8Yyb4KH3A1LBVX1sI5D08W4McVsGvylxy93u_vfkcrz1XhP_4bx
 EkVbCaVuJL3EZxTWwQNXULgZiC9Rbi6t0DK_GJ5ADJIu3qkYZbd9FgOtUvuv
 NJOjUJuZjmT63LLWAb0nmTGm2VeX2QKfK3kRKPNVRCdDyuDw-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214174847.887713690@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 11:48:47 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V1 0/4] this_cpu_cmpxchg_double support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces this_cpu_cmpxchg_double().

x86 cpus support cmpxchg16b and cmpxchg8b that can be used to perform a
cmpxchg with two words instead of only one. That allows to put more state
into an atomic instruction.

this_cpu_cmpxchg_double() is then used in the slub allocator to avoid
interrupt disable/enable in both alloc and free fastpath.
this_cpu_cmpxchg_double works nicely with the per cpu data of the
allocator. Doing so significantly speeds up the fastpaths.

