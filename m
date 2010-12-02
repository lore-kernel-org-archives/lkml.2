Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0LBI6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 03:58:47 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52189 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab0LBI6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 03:58:45 -0500
Message-ID: <4CF75FC2.6080108@linux.vnet.ibm.com>
Date: Thu, 02 Dec 2010 00:58:42 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events into
 a group produces no counts on member events
References: <4CF59E20.1040301@linux.vnet.ibm.com>
In-Reply-To: <4CF59E20.1040301@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 05:00 PM, Corey Ashford wrote:
>
> Hi,
>
> I'm not sure that what I'm seeing is a bug, or was something intentional.
>
> If I place multiple tracepoint events into a group and measure counts of
> these events on a process, I get no counts for the tracepoint events
> other than the group leader.
>
> Is this expected behavior?
>
> It's not clear to me why this should be the case; grouping shouldn't
> have any ill effects on tracepoint events, from my understanding.
>
> I noticed this because my private version of the perf tool has the event
> group patch https://lkml.org/lkml/2010/11/24/584 as well as the patch
> which fixes the parsing of multiple tracepoint events in the same -e
> switch: https://lkml.org/lkml/2010/11/30/460
>
> When I dig into the code a bit, I find that each event opens
> successfully, so that's not the problem. If I disable the grouping, then
> I get counts for all of the tracepoint events.

False alarm.  I found a bug in my forwarded-ported version of the event 
grouping patch for perf stat.  I was setting the attr->disabled bit for 
all of the events instead of just the group leader, when forking off the 
command.

Software events, tracepoints, and hardware events all work when grouped 
now.  Sorry, I should have been more thorough in testing this on other 
types of events.  I had thought I had it working with hardware events, 
and it was, but only if I attached to an existing process, not when 
forking off a new command.  Anyway, if I had tested with hardware events 
in the same way I had tested tracepoints I would have seen the problem.

So the patch mentioned above, https://lkml.org/lkml/2010/11/24/584, has 
a bug, but since it didn't get committed, I suppose it's not a problem. 
  If anyone is still interested, I can post a v4 of that patch.

Sorry for the bother!

- Corey
