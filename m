Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2EGRLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:11:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57466 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab2EGRLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:11:16 -0400
Subject: Re: [PATCH 3/7] perf tools: Add parser for dynamic PMU events
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120507170549.GM18810@erda.amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
	 <1335983192-23731-4-git-send-email-robert.richter@amd.com>
	 <1336388463.27020.3.camel@laptop>  <20120507170549.GM18810@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 19:10:55 +0200
Message-ID: <1336410655.27020.74.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 19:05 +0200, Robert Richter wrote:
> On 07.05.12 13:01:03, Peter Zijlstra wrote:
> > On Wed, 2012-05-02 at 20:26 +0200, Robert Richter wrote:
> > > This patch adds support for pmu specific event parsers by extending
> > > the pmu handler. The event syntax is the same as for tracepoints:
> > > 
> > >  <subsys>:<name>:<modifier> 
> > 
> > I really don't like this
> > 
> > > -          event_legacy_tracepoint sep_dc |
> > > +          event_legacy_generic sep_dc |
> > 
> > That 'legacy' in there is a good hint you shouldn't be using this.
> > 
> > Ideally I'd get rid of all legacy formats eventually, we really
> > shouldn't be adding new ones. 
> 
> Anyway, we need something like this to specify event names (pseudo
> event names in case of ibs) and userland filter options. Though, it
> must not necessarily this syntax but something else. The one above
> looks esthetic to me while some other event syntax is close to a perl
> regex. ;)

Jiri and Yan Zheng are working on something that would allow:

 ibs_op/foo/

Their solution will initially get foo from sysfs (ibs_op/events/foo),
but an external lookup should also get there. Stephane also wants/needs
something like that to plug the Intel event names in.



