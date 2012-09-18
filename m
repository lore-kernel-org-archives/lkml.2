Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab2IRHqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:46:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:40995 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab2IRHqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:46:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,441,1344236400"; 
   d="scan'208";a="223379368"
Date: Tue, 18 Sep 2012 15:40:10 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <andi@firstfloor.org>,
        <namhyung@kernel.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/7] perf ui/browser: Integrate script browser into
 annotation browser
Message-ID: <20120918154010.451e5891@feng-i7>
In-Reply-To: <20120917152301.GB16820@infradead.org>
References: <1347007349-3102-1-git-send-email-feng.tang@intel.com>
	<1347007349-3102-7-git-send-email-feng.tang@intel.com>
	<20120917152301.GB16820@infradead.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Thanks for the reviews!

On Mon, 17 Sep 2012 12:23:01 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Fri, Sep 07, 2012 at 04:42:28PM +0800, Feng Tang escreveu:
> > Integrate the script browser into annotation, users can press function
> > key 'r' to list all perf scripts and select one of them to run that
> > script, the output will be shown in a separate browser.
> 
> I think this needs a bit more work... i.e. I tried it with your script,
> event_analyzing_sample and I kinda get meaningful output when pressing
> 'r' + that script from the top and hists browser.

I would answer you question about "elllaborate on the assumptions" first
here, that the main purpose of this script browser is not to replace the
normal "perf script" command, but to:
1. Provide a convenient way for user to directly run scripts while they
are browsing through the hists or annotation browser, and provide some
option for run script with samples from specific thread or symbol
2. Prepare for some advance feature, like inside the annotation browser,
analyze some specific hot line of code with samples containing precise
information, like the register values, store/load latency stuff. But I
have no idea how to implement it now, I guess after Stefan work out the
general perf latency tool, we may be able to revisit it.   

And when I started to code, I assumed user will mainly use this feature
for running scripts for general samples other than the existing scripts
for tracepoints. And yes, some user cases you mentioned are not covered.

> 
> But with other scripts, and you filtered the -top suffixed ones, that
> require special handling, I get things like "Press Control+C to get a
> summary", and when I press that, the browser exits, going back to
> annotate or report/top browser.

That's right, 4 current perf python scripts will print that line in its
"trace_begin" function, as some of the scripts may run for quiet some
time if the perf.data is huge. And what you see in the script browser 
is just some static text of the script output. 

> 
> I.e. this only works if we are processing a perf.data file made
> specially for that specific script, right? I.e. the record phase is not
> integrated at all, just running specific scripts in specific perf.data
> files.

No, the record phase is not added, it just handle the recorded data. And
there is something missed in current implementation, that the script in
browser mode is only run for the "perf.data" even if the perf report/annotate
is run for data with another name.

> 
> How to allow the user to chose appropriate scripts to run each perf.data
> file is an aspect of usability that is missing...

Do we need to run script for another perf.data when we run report/annotation
for one perf.data? or should we add a option for script browser to make it
work in browser mode, this is something Numhyung has mentioned in his review

Thanks,
Feng

> 
> Can you ellaborate on the assumptions you made while working on this, do
> they match what I described above as how to use this scripts browser?
> 
> So I merged part of this patchset, but will wait till more discussion
> happens on the browsing part,
> 
> Thanks,
> 
> - Arnaldo
