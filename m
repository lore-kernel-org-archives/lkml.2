Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0K3TIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:08:44 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:37316 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751260Ab0K3TIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:43 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: U_skQY8VM1mizt9ksLt0vlCvtzrmKYVa9bK9vRI78yra5Ie
 zu5bayTZJEkolvQXIsLnvbupUWojDfHskCoOBSuBPAUA9000FOt4gRx3P2qs
 BNlc_ACp7LQlHz4AEY5M_kGYMs6HVZsnJ.buhJduK9XTljJb6Np5BzeJnsmk
 CIPoKjotDGI8XsHsBxvj9UZ2V4zeeJJ4bszhHW5epIGZmbQsYIdUW._STycf
 OS_tiQVDwtrqtoUyGaC5o0TL3PH3yaz68wlb5R.eme518nJ3OYg--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190707.457099608@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:07 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 00/18] Upgrade of this_cpu_ops V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patchset that adds more this_cpu operations and in particular RMV operations
that can be used in various places to avoid address calculations and
memory accesses by the user of fast cpu local operations with segment
prefixes.

V2 has several enhancements and bugfixes that were suggested after V1

V3 removes the cmpxchg patches and focuses on the first extensions
of cpu ops that were generally an improvement.

For V3 I scanned through the kernel code for obvious cases in which a
__get_cpu_var or get_cpu_var can be converted to this_cpu_ops. That is
often not possible because addresses of per cpu variables are needed.
However, the accesses that could become converted became very cheap
because this_cpu_ops typically only generate a single instruction using
a segment prefix to perform the relocation to the correct per cpu area.

Cpu ops perform implied address calculations. It is therefore not possible
to take the address of the result of a this_cpu_xx operation.

