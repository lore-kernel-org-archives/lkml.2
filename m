Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab0KLRmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:42:12 -0500
Received: from ms01.sssup.it ([193.205.80.99]:51833 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751650Ab0KLRmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:42:10 -0500
Message-ID: <4CDD7C6F.5000100@sssup.it>
Date: Fri, 12 Nov 2010 18:42:07 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
References: <1288333128.8661.137.camel@Palantir>	 <1288333622.8661.141.camel@Palantir> <1289579924.12418.404.camel@gandalf.stny.rr.com>
In-Reply-To: <1289579924.12418.404.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/11/2010 17:38, Steven Rostedt ha scritto:
> A while ago I implemented an EDF scheduler for a client (before working
> with Red Hat), and one thing they asked about was having a "soft group",
> which was basically: This group is guaranteed X runtime in Y period, but
> if the system is idle, let the group run, even if it has exhausted its X
> runtime.
>
> Is this supported?
Actually, I know that Dario has an implementation of exactly this 
feature (and it used to be implemented in our previous scheduler as 
well, i.e., the old AQuoSA stuff):
a per-task flag, when enabled, allows to put temporarily the task into 
SCHED_OTHER when its budget is exhausted. Therefore, it will be allowed 
to run for more than its budget but without breaking the temporal 
isolation with the other SCHED_DEADLINE tasks. Furthermore, it won't 
starve other SCHED_OTHER tasks, as it will compete with them for the CPU 
during the budget-exhausted time windows.

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

