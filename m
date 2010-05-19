Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab0ESHJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:09:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43059 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0ESHJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:09:51 -0400
Date: Wed, 19 May 2010 09:09:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100519070919.GA9618@elte.hu>
References: <4BF2392A.9040409@jp.fujitsu.com>
 <4BF2C3D1.10009@redhat.com>
 <1274204560.17703.82.camel@Joe-Laptop.home>
 <20100518185305.GA23921@elte.hu>
 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
 <20100518191802.GG25224@aftab>
 <m1k4r0c0y7.fsf@fess.ebiederm.org>
 <20100518222832.GJ22675@basil.fritz.box>
 <m1wrv0zo9q.fsf@fess.ebiederm.org>
 <20100519064619.GA30320@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519064619.GA30320@aftab>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Tue, May 18, 2010 at 09:14:09PM -0400
> 
> > - Errors that occur frequently. That is broken 
> >   hardware of one time or another.  I want to know 
> >   about that so I can schedule down time to replace my 
> >   memory before I get an uncorrected ECC error.  
> >   Errors of this kind are likely happening frequently 
> >   enough as to impact performance.
> 
> This is exactly the reason why we need a better error 
> logging and reporting than a log.
>
> [ ... lots of specific details snipped ... ]

Basically the idea behind the generic structured logging 
framework (the perf events kernel subsystem) is to have 
both ASCII output (where desired: critical errors), but to 
also have well-specified event format parsable to 
user-space tools.

Plus there's the need for fast, lightweight, flexible 
event passing mechanism - which is given by the perf 
events transport which enables arbitrary size in-memory 
ring-buffers, poll() and epoll support, etc.

perf events supports all these different usecases and 
comes with a (constantly growing) set of events already 
defined upstream. We've got more than a dozen different 
upstream subsystems that have defined events and we have 
over a hundred individual events. There's a rapidly 
growing tool space that makes case by case use of these 
event sources to measure/observe various aspects of the 
system.

Regarding dmesg, there's a WIP patch on lkml that 
integrates printks into this framework as well - makes 
each printk also available as a special string event.

That way a tool can have both programmatic access to 
printk output (without having to interact with the syslog 
buffer itself) - together with all the other structured 
log sources, while humans can also see what is happening.

Thanks,

	Ingo
