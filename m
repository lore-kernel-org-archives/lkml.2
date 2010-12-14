Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab0LNQ24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:28:56 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:39568 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757409Ab0LNQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:28:55 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: dR5heW4VM1mm0wz7JF8FSwxCKtGcoN6UN0E5r9Y9XdDiKVe
 ichavo3Z_Le6Sl31vNkFA.XGv2NQSnwBpslswp2Xf008h6YKXCnYhYKIuNoU
 D0Rly8DjsbrmOAZ3yMYmeApqk.zgrACIvY0HpS1dVLbkwMboLkj2I2RN.rJP
 661zZqbM7ZZ2C9cGx413zzqHeWAG6L3Tjts4m.E.M4Ym40p2J.xBbawNTD.l
 cJCZZkMt7barOwQjcAXGWErNOo.sb8udUBojzpjoThy_UpsZF.j6MPs1.sZO
 m22d6Jov8DtEpvpLQchwVgsDbFyql7Ohei_DOMvF.Sc7dorY-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214162842.542421046@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 10:28:42 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg V2 0/5] Cmpxchg and xchg operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cmpxchg and xchg operations to the cpu ops and use them for irq handling
and for vm statistics.

Requires the per cpu patches for and_return cpu ops.

V1->V2:
	- Determine that cmpxchg without LOCK is faster than xchg with
	 	implied lock (numbers are in the patch description).
	- Drop 64 bit cpuops operations on 32 bit x86 (resulted in various
		nasty things such as 64 bit alignment requirements for 64 bit
		entities on 32 bit, sizable inline code and very complex macros)


