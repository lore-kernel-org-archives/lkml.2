Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0KXDJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 22:09:57 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:37392 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751955Ab0KXDJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 22:09:56 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: HFD6rQcVM1nfSMgeLZG9GRLjT2yz524YYzM4U1a.Z88bp6P
 5H_MfYKc3V7PK53x7Q2HkqSJ1BX_EJ_BuVEtLdTDxieS05YgrxwDdHfxNWHO
 Sygc_ZZXTHkQ1e.xJ4Zze_eP16A_QO2aUE3UrGH5eJeJtexUhnQq1.jqR1B_
 CuVNi8stmcsPDGa1mJttfFXp.yTN_4eoo6ZE_XxPL0VJ71gsk.FxpIr2_eI4
 XP1lFLOTQ9QA-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 23 Nov 2010 21:09:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [thiscpuops upgrade 10/10] Lockless (and preemptless) fastpaths
 for slub
In-Reply-To: <20101124010554.GC8264@Krystal>
Message-ID: <alpine.DEB.2.00.1011232109001.7446@router.home>
References: <20101123235139.908255844@linux.com> <20101123235201.758191189@linux.com> <20101124010252.GB8264@Krystal> <20101124010554.GC8264@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010, Mathieu Desnoyers wrote:

> Ah! I knew I was missing something: the second cmpxchg will fail because it
> expects "tid", but the value is now the "next_tid". So effectively, many
> instances of the same transaction can run concurrently, but only one will
> succeed.

Right.

> Sorry for the noise.

No its good to hear that you were not able to find a hole on first glance.
