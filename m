Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2EHPSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:18:54 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:45047 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755671Ab2EHPSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:18:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pUazTMAVM1nvCPXwWynTUFoi1C6GmoAVHAHdT8fzLPYdM1H
 knyJ2a29hsNRgd177qnjh40_sw0fnG7sUCmFnNhKZC7mX5r1cxWh4MjFjX6c
 UJiQ6T8ggkdxBYuqxjFwmeE5EIsYVRu.b2MNUPkM1eGMoUytEyGzyhUXSFOk
 EAEYeh3hpOaiq0ooPgMiPmr84SKK5Y0N0fztcZCQMWNOmv0iPQlnv8uOyELC
 FMIdNdeh4.o32cvpkviACI_cS9s9Zi8ZcHpZuL9XXi3kiL4tFOccD9BhlI74
 5zLxw_Rn8Oqh19phq4UjbKsgBpmqviexfnyORYpPO6yy4rkaUniSw223Z6qq
 52wa8isLw2jxYrb_ioUobyuiLv_9Eycw2SlMbzBTUneg1uqSkAjznIxYicX3
 y
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 10:18:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
In-Reply-To: <1336488626.16236.41.camel@twins>
Message-ID: <alpine.DEB.2.00.1205081016370.27713@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-8-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1205071053070.1060@router.home> <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
 <1336488626.16236.41.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Peter Zijlstra wrote:

> There's no such policy, but I don't get why Christoph objects to
> cpusets, its the option I would prefer. You're going to use cpusets
> anyway to partition your system, might as well also use it to mark a
> whole partition/set as nohz.

We are currently not using cpusets but are simply isolating processors as
needed. Not sure that I want the overhead (administratively as well as in
kernel) to deal with this.

Someone may be using a different partitioning technique (like cgroups) etc
and then wont be able to use nohz. Having it not depend on cpusets makes
it more universal.

