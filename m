Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0LABAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:00:24 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50537 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab0LABAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:00:23 -0500
Message-ID: <4CF59E20.1040301@linux.vnet.ibm.com>
Date: Tue, 30 Nov 2010 17:00:16 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [BUG(?)] perf_events: combining multiple tracepoint events into a
 group produces no counts on member events
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm not sure that what I'm seeing is a bug, or was something intentional.

If I place multiple tracepoint events into a group and measure counts of 
these events on a process, I get no counts for the tracepoint events 
other than the group leader.

Is this expected behavior?

It's not clear to me why this should be the case; grouping shouldn't 
have any ill effects on tracepoint events, from my understanding.

I noticed this because my private version of the perf tool has the event 
group patch https://lkml.org/lkml/2010/11/24/584 as well as the patch 
which fixes the parsing of multiple tracepoint events in the same -e 
switch: https://lkml.org/lkml/2010/11/30/460

When I dig into the code a bit, I find that each event opens 
successfully, so that's not the problem.  If I disable the grouping, 
then I get counts for all of the tracepoint events.

- Corey

