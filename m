Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0FDEyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:54:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45760 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0FDEyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <20100603232302.GA16184@elte.hu>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
Date: Thu, 3 Jun 2010 21:54:50 -0700
Message-ID: <AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 4:23 PM, Ingo Molnar <mingo@elte.hu> wrote:
...
>  - Controlled auto-suspend: drivers (such as input) could on wakeup
>   automatically set the 'minimum wakeup latency' value of wakee tasks to a
>   lower value. This automatically prevents another auto-suspend in the near
>   future: up to the point the wakee task increases its latency (via the
>   scheduler syscall) again and allows suspend again.
>

How do you clear the latency value in a safe way? If another wakeup
event happens right after your wakee task is done processing the last
event and decides to increase its latency, auto suspend will be
allowed even though you have an unprocessed wakeup event. Also how do
you know which task will read the event if it is not already waiting
for it?


>   This means there will be no surprise suspends for a task that may take a
>   bit longer than usual to finish its work. [ Detail: this would only be done
>   for tasks that have a non-default (non-infinity) task->latency value - to
>   prevent the input driver from lowering latency values (and preventing
>   future suspends) just because some unaware apps are running and using input
>   drivers. ]

Don't you need two inifinity values for this?

-- 
Arve Hjønnevåg
