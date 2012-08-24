Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab2HXSM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:12:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39548 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab2HXSMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:12:18 -0400
Date: Fri, 24 Aug 2012 20:12:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC 00/13] perf test: Add perf_event_attr tests
Message-ID: <20120824181211.GA32273@gmail.com>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
 <20120824130706.GA27708@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824130706.GA27708@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Fri, Aug 24, 2012 at 11:00:31AM +0200, Jiri Olsa escreveu:
> 
> >  tools/perf/util/test-attr.c                         | 142 ++++++++++++++++++++++++++
> >  tools/perf/util/test-attr.py                        | 272 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/test-attr/base-record               |  39 ++++++++
> 
> I suggest we move all this to:
> 
>   tools/perf/tests/attr/

Yes!

I'd even strongly suggest increasing perf test's prominence 
within the project: if the tests are quick enough to run we 
could run them during the build of perf and warn if perf test 
fails in an unexpected way with the new perf binary.

( Running new perf on older kernel should never cause an 
  unexpected failure and thus a build warning. )

So as people are working on new perf patches, the default build 
will run perf test and will catch some errors. As the number of 
testcases grows it might catch a wide range of bugs. It will 
also help us find regressions sooner, when users/testers build 
perf they'll always run perf test as well and report new 
warnings/failures.

Thanks,

	Ingo
