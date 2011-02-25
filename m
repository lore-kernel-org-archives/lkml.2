Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab1BYRl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:41:57 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:38493 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753069Ab1BYRl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:41:56 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Ycbgl5IVM1kNUfg39hDB_qeca61iZimqxXgkEzkOTPdFU9i
 rpCw1TzND224TxY.mUOKt81Nbt8Qir3tqG.KWEo2ZqrV9rwI_HqIntsVz3k9
 14nBP17a1RzqS2loAlE_JgfbOaz6DPhOLioVi17y16KMhZ6BWO9FxQLMUhAh
 LzhhjJrSidueoYgX7hwb5wc2R669rvUnyuUlEZAnAnDC5AZoN6y5QO8MRs9I
 DijfnS7NyptxVnHndtuYfuKl43YM6ApkX2J419jXH3sEv5xZh.nYOkFCFBql
 ItbmTeB4WXkp154HConi2EyLHvGDOC55n7a7KQXZMWdG7iM0-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110225173850.486326452@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 25 Feb 2011 11:38:50 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V3 0/5] this_cpu_cmpxchg_double support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces this_cpu_cmpxchg_double().

x86 cpus support cmpxchg16b and cmpxchg8b instuction which are capable of
switching two words instead of one during a cmpxchg.
Two words allow to swap more state in an atomic instruction.

this_cpu_cmpxchg_double() is used in the slub allocator to avoid
interrupt disable/enable in both alloc and free fastpath.
Using the new operation significantly speeds up the fastpaths.

V1->V2
	- Change parameter convention for this_cpu_cmpxchg_double. Specify both
	  percpu variables in same way as the two old and new values.
	- Do not require a per cpu pointer but a variable to conform to the
	  convention used in other this_cpu_ops.

V2->V3:
        - Do not use CONFIG_DEBUG_VM to enable cmpxchg diagnostics. Use
          custom SLUB define instead.
        - Add patch to move min_partial into a different cacheline.
        - Rediff

