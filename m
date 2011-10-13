Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab1JMND2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 09:03:28 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:57683 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646Ab1JMND0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 09:03:26 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Oct 2011 09:03:25 EDT
X-AuditID: 12074424-b7ef76d0000008dc-9a-4e96e0706e71
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org
Cc: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH 1/2] VFS: New /proc file /proc/self/mountstats
References: <20050317162613.756101BB98@citi.umich.edu>
From: stark@MIT.EDU
Date: 13 Oct 2011 08:58:20 -0400
Message-ID: <ycqsjmx9hg3.fsf@multics.mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsUixG6nolvwYJqfwY4tEhb/7z5nstiz9ySL
	xeVdc9gsLhw4zerA4vHx6S0Wj8+b5AKYorhsUlJzMstSi/TtErgyjr7rZSy4xFnxfOktpgbG
	9+xdjJwcEgImEtsWr2aBsMUkLtxbz9bFyMUhJLCPUeL7zr8sEM4GRomJ79ZBOYeYJP60nmGF
	cJoYJc5cncQE0i8ikCxxavIPsFnMAhoS93qnsoHYwgJOEpdnbQbaxwHUYCax93URSJhNQFji
	4JMFYOUsAgoSm1u2g9m8AroS5w98AjuPR4BT4uXJjYwTGPkWMDKsYpRNya3SzU3MzClOTdYt
	Tk7My0st0jXXy80s0UtNKd3ECA4iF5UdjM2HlA4xCnAwKvHwnnSe5ifEmlhWXJl7iFGSg0lJ
	lLfgHlCILyk/pTIjsTgjvqg0J7X4EKMEB7OSCG/aUaAcb0piZVVqUT5MSpqDRUmc12ang5+Q
	QHpiSWp2ampBahFMVoaDQ0mCd/59oEbBotT01Iq0zJwShDQTByfIcB6g4fEgNbzFBYm5xZnp
	EPlTjIpS4rzZIAkBkERGaR5cLyzKXzGKA70izLsQpIoHmCDgul8BDWYCGmxyeCrI4JJEhJRU
	A2PqNZ2d5lFxs20kDj2vcDdvVVVWkOQRX+K/KXnVCXUjgz1XbjxN3f0u0zLsto2xlKCMWlCh
	+tPC9O3Jp66vyAk40Rh54PyvJR0vGBc/s1vKsObPwn4xp+u7p5jrSZ79kyeR6iG/dE/w24TG
	G3OdFL1UeD/d9fnD/+WnGV+2q1ua+p3FR6yuzVBiKc5INNRiLipOBABjejAkzQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chuck Lever <cel <at> citi.umich.edu> writes:

> Create a new file under /proc/self, called mountstats, where mounted file
> systems can export information (configuration options, performance counters,
> and so on). Use a mechanism similar to /proc/mounts and s_ops->show_options.

I'm using this file to dump data into our performance metrics database along
with all the other counters from snmp and other sources. This lets us
calculate things like the average number of requests pending, average latency
per request over time.

But I have a few questions about the meaning of the values and they don't seem
to be documented outside the comments in the source. 

In particular is it an invariant that execution = rtt + queue? Or is execution
including some additional overhead other than the server and network
congestion? Or is there something more subtle going on and these values aren't
related in the way I'm imagining at all?

And where can I read about the meaning of bad_xids, req_u, and bklog_u? What
do they mean?

Also, connect_time, idle_time, req_u, and bklog_u are instantaneous samples
("guages" so to speak), not integrated over time right? So they can't be used
to calculate any aggregates?
