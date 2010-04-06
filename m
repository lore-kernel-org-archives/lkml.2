Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab0DFK2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:28:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56643
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706Ab0DFK2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:28:47 -0400
Date: Tue, 06 Apr 2010 03:28:50 -0700 (PDT)
Message-Id: <20100406.032850.137831355.davem@davemloft.net>
To: fweisbec@gmail.com
Cc: rostedt@goodmis.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
       a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
 events on sparc 64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100406101925.GD5147@nowhere>
References: <20100405194055.GA5265@nowhere>
	<20100406.025049.267615796.davem@davemloft.net>
	<20100406101925.GD5147@nowhere>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 6 Apr 2010 12:19:28 +0200

> It means having such interrupt reentrancy is not a problem.

It's not reentrancy.

It's the fact that local_irq_disable() (read it again, it's the
"disable" that re-renables NMIs on sparc64) turns NMIs back on even in
code where we are still trying to figure out how to service the NMI
still.

It's because we implement NMIs on sparc64 by having the performance
counter interrupt come in on the level 15 interrupt, and we run the
entire kernel at level 14 when IRQs are "disabled".
