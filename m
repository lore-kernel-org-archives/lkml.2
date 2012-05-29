Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab2E2McU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:32:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:54811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2E2McT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:32:19 -0400
Message-ID: <1338294716.26856.55.camel@twins>
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
Date: Tue, 29 May 2012 14:31:56 +0200
In-Reply-To: <4FC4BE9F.9060102@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
	   <1337809375-24295-14-git-send-email-juri.lelli@gmail.com>
	  <1337942292.9783.178.camel@laptop> <4FC0B95C.5060207@gmail.com>
	 <1338285486.26856.16.camel@twins> <4FC4BE9F.9060102@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 14:18 +0200, Juri Lelli wrote:
> > The thing is, keeping it separate makes for an impossible configuration
> > scenario. Esp. once we enable !root usage. The proposed 5% is very
> > limiting and regular users won't have sufficient privilege to change it.
> >
> 
> Ok, now I understand your point better, and I agree that 5% is hardly
> usable for !root users. However, I also think this is probably more a
> system admin problem. I mean, a sys admin that wants his users to play
> with -deadline scheduling should have thought how to properly set up his
> system, and the fact that something must be configured by hand to give
> users a usable system is generally not a so bad idea. 

Yes, but lets not make the life of the unsuspecting admin harder than we
absolutely have to.

Furthermore we should strive to make DL as useful as possible
out-of-the-box.

One way to do this is to have rt and dl bandwidth constraints
independent and put a 3rd combined limit in place. But what is the
benefit of that over a single combined limit?
