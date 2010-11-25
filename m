Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab0KYGcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:32:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:52285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0KYGcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:32:51 -0500
Subject: Re: [RFC PATCHv3] perf tools: add event grouping capability to
 "perf stat"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
References: <1290650053-3486-1-git-send-email-cjashfor@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 07:32:40 +0100
Message-ID: <1290666760.2072.539.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 17:54 -0800, Corey Ashford wrote:
> Add the ability to create multiple event groups, each with their own leader
> using the existing "-e <event>[,<event> ...] [-e <event>[,<event>]]"
> syntax.  Each additional -e switch creates a new group, and each event
> listed within a -e switch is within that group.
> 
> Changes since v1:
> - Because of a flub, v2 did not contain the changes I had intended to make,
> and instead, v2 had the same patch contents as v1.
> - When perf stat is not supplied any events on the command line, put
> each default event in its own group.

I like this, but could you also extend this to perf-record? its a bit
odd to diverge between the two.

Using Stephane's latest syntax changes you could actually do something
like:

perf record -e task-clock:freq=1000,cycles:period=0

Which would create a group with 1 sampling counter and a counting
counter (at which point we should probably start flipping
PERF_SAMPLE_READ).

Matt was working on supporting that (although not through cmdline
syntax) and teaching perf-report to cope with such output.

