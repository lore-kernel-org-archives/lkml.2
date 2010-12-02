Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab0LBVyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:54:05 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:38150 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757989Ab0LBVyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:54:01 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vrp7_uUVM1mnBr.bm1zvttSjJGaHjHu9hmKXWwscQ0KBxJ1
 FgVHbADzeRs5Hx_r1GrrMHSJgNAGQLoHM.Q3UqPSA0SLG67mJ9XmosYJ_MSj
 9GgLat9tdQ4QfiyyAN0Pum8GCcUq_swardABKLm3aITxlHxwJtgwLqox3Z40
 aK.MHr9zRjoWfQ2PZBR_62J3DmCBk65dRtyCFcmjuwyt6QuWEihSbYdH.XbH
 Ww1WkGE4n9ZE-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101202215340.562309713@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 15:53:40 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [rfc: cpuops adv V1 0/8] Cmpxchg and xchg support for cpu ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patchset on top of the thiscpuops upgrade patchset. It
adds cmpxchg and xchg support and uses that to improve various
kernel subsystem.

For vm statistics we can avoid interrupt enable/disable which reduces
the latencies of the vm counter updates to a fraction.

The slub fastpaths and slowpaths can decrease their cycle count. In
particular it is possible to improve the performance of the free slowpath.

