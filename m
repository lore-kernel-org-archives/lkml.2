Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0KJTRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:17:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:35360 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab0KJTRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:17:38 -0500
Subject: Re: [RFC][PATCH 04/22] sched: SCHED_DEADLINE SMP-related data
 structures
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
In-Reply-To: <1288333746.8661.144.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333746.8661.144.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 20:17:39 +0100
Message-ID: <1289416659.2084.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:29 +0200, Raistlin wrote:
> @@ -1336,6 +1336,7 @@ struct task_struct {
>  
>         struct list_head tasks;
>         struct plist_node pushable_tasks;
> +       struct rb_node pushable_dl_tasks; 

Shouldn't these be CONFIG_SMP too? Not much use in tracking pushable
tasks when there's nothing to push them to, eh?


