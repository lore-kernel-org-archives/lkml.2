Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab0KKT6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:58:00 -0500
Received: from canuck.infradead.org ([134.117.69.58]:34562 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab0KKT56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:57:58 -0500
Subject: Re: [RFC][PATCH 13/22] sched: add resource limits for -deadline
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288334250.8661.154.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334250.8661.154.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 20:57:51 +0100
Message-ID: <1289505471.2084.191.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:37 +0200, Raistlin wrote:
> Add resource limits for non-root tasks in using the SCHED_DEADLINE
> policy, very similarly to what already exists for RT policies.
> 
> In fact, this patch:
>  - adds the resource limit RLIMIT_DLDLINE, which is the minimum value
>    a user task can use as its own deadline;
>  - adds the resource limit RLIMIT_DLRTIME, which is the maximum value
>    a user task can use as it own runtime.
> 
> Notice that to exploit these, a modified version of the ulimit
> utility and a modified resource.h header file are needed. They
> both will be available on the website of the project.

We might also want to add an additional !SYS_CAP_ADMIN global bandwidth
cap much like the existing sysctl bandwidth cap.


