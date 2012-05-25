Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2EYKic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:38:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2EYKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:38:31 -0400
Subject: Re: [PATCH 13/15] sched: add bandwidth management for sched_dl.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
In-Reply-To: <1337809375-24295-14-git-send-email-juri.lelli@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
	 <1337809375-24295-14-git-send-email-juri.lelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 12:38:12 +0200
Message-ID: <1337942292.9783.178.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 23:42 +0200, Juri Lelli wrote:
> +/*
> + * Coupling of -dl and -rt bandwidth.
> + *
> + * Here we check, while setting the system wide bandwidth available
> + * for -dl tasks and groups, if the new values are consistent with
> + * the system settings for the bandwidth available to -rt entities.
> + *
> + * IOW, we want to enforce that
> + *
> + *   rt_bandwidth + dl_bandwidth <= 100%
> + *
> + * is always true.
> + */ 

I was thinking we could do it the other way around, have have
dl_bandwidth included in rt_bandwidth.



