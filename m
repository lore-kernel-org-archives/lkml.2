Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab0KJX5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:57:12 -0500
Received: from ms01.sssup.it ([193.205.80.99]:55267 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757116Ab0KJX5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:57:10 -0500
Message-ID: <4CDB2340.2060501@sssup.it>
Date: Wed, 10 Nov 2010 23:57:04 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Raistlin <raistlin@linux.it>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [RFC][PATCH 02/22] sched: add extended scheduling interface
References: <1288333128.8661.137.camel@Palantir>	 <1288333622.8661.141.camel@Palantir>  <1289410114.2084.23.camel@laptop> <1289427476.13577.285.camel@Palantir>
In-Reply-To: <1289427476.13577.285.camel@Palantir>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/11/2010 23:17, Raistlin ha scritto:
>> I would suggest we add at least one more field so we can implement the
>> stochastic model from UNC, sched_runtime_dev or sched_runtime_var or
>> somesuch.
> Do we need some further mechanism to grant its
> extendability?
> Padding?
> Versioning?
> void *data field?
> Whatever?
This is a key point. Let me copy text from a slide of my LPC main-conf talk:

Warning: features & parameters may easily grow
- Addition of parameters, such as
     - deadline
     - desired vs guaranteed runtime (for adaptive reservations & 
controlled overcommitment)
- Set of flags for controlling variations on behavior
     - work conserving vs non-conserving reservations
     - what happens at fork() time
     - what happens on tasks death (automatic reclamation)
     - notifications from kernel (e.g., runtime exhaustion)
- Controlled access to RT scheduling by unprivileged
    applications (e.g., per-user “quotas”)
- Monitoring (e.g., residual runtime, available bandwidth)
- Integration/interaction with power management
    (e.g., spec of per-cpu-frequency budget)

How can we guarantee extensibility (or replacement) of parameters in the 
future ?

What about something like _attr_*() in POSIX-like interfaces ?

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

