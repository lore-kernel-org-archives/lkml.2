Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0KJTnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:43:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:43590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab0KJTnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:43:37 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
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
In-Reply-To: <1288333814.8661.146.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 20:43:34 +0100
Message-ID: <1289418214.2084.48.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> + * We are being explicitly informed that a new instance is starting,
> + * and this means that:
> + *  - the absolute deadline of the entity has to be placed at
> + *    current time + relative deadline;
> + *  - the runtime of the entity has to be set to the maximum value.

When exactly are we a new instance? From a quick look dl_new gets set
after a sched_setscheduler() call, is that the only way?

Could a task calling sched_setscheduler() on itself cheat the system?
