Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab1HBKil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:38:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1HBKig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:38:36 -0400
Subject: Re: [PATCH 6/7] perf, x86: Example code for AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Michael Cree <mcree@orcon.net.nz>,
        Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <20110801055008.GZ4590@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311860812-28748-7-git-send-email-robert.richter@amd.com>
	 <1311958729.5890.413.camel@twins>  <20110801055008.GZ4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Aug 2011 12:37:54 +0200
Message-ID: <1312281474.1147.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 07:50 +0200, Robert Richter wrote:
> On 29.07.11 12:58:49, Peter Zijlstra wrote:
> > On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > >  tools/perf/Documentation/examples/ibs.c    |  436 ++++++++++++++++++++++++++++
> > 
> > That really isn't the place for this..
> > 
> > Also, how similar is the Alpha PMU to AMD IBS?
> 
> Would you prefer
> 
>  tools/perf/Documentation/examples/x86/ibs.c
> 
> instead?

Possibly, but having just looked at the example again I don't really see
it doing anything perf-record doesn't already do, so why does it deserve
to live at all?

Initially I thought it was a record+report like example, some code
interpreting the 'mess' that comes out of IBS would be most appreciated
and I think we can even ship that as perf-ibs-report/perf-ibs-annotate
or so (and if its still remotely similar to its Alpha precursor that
might make the Alpha folks happy too).

> Actually I wasn't sure if this place is ok at all. But I wanted to
> publish the code for reference and testing. There isn't somthing
> similar already there, and the perf tool code is also not the best
> place to implement such cpu specific features.
> 
> But putting it to the documentation is common practice for library
> packages (e.g. libpapi and libpfm). If the example is not for the
> given architecture it won't be added to the package documentation.
> This example won't be installed at all. Even for very special features
> an example is important since it is often not part of the generic
> implementation.

Right, its just that I'm not seeing the extra value at all, aside from
maybe the IBS_*_DEFAULT values that should live as an event config
(poking mlin to see where he's at with those patches..).
