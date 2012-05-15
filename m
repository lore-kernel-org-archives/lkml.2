Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964938Ab2EODWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964929Ab2EODWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 23:22:35 -0400
Message-ID: <1337052146.1860.11.camel@freedom>
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
From: Lucas Meneghel Rodrigues <lmr@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 00:22:26 -0300
In-Reply-To: <20120515014633.GD4254@infradead.org>
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
	 <87sjf31a8c.fsf@sejong.aot.lge.com> <4FB1041C.1050903@gmail.com>
	 <87k40e1cco.fsf@sejong.aot.lge.com> <4FB1B486.4020509@gmail.com>
	 <20120515014633.GD4254@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 22:46 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, May 14, 2012 at 07:42:30PM -0600, David Ahern escreveu:
> > On 5/14/12 7:07 PM, Namhyung Kim wrote:
> > >>Something else is wrong then. I tested that command (saw your patch in
> > >>the history) and it worked for me. Also, this code path does not
> > >>affect perf-stat -- it touches perf-record and perf-test only.
> 
> > >Ah, right. But still wouldn't it be better changing the conditional
> > >rather than disabling it unconditionally?
> 
> > I think it would be best to disable all events initially and then
> > enable them when ready. It works for perf-record and perf-test just
> > fine and limits the samples to what you care about.
> 
> And we need to have all this logic in a central place, the "open" method
> of perf_evlist :-)
> 
> The perf_target abstraction is the way to get there, but in the process
> I think we really need to have each new method with a 'perf test' entry
> and in addition to that an 'autotest'* entry to test the perf builtins.
> 
> - Arnaldo

Right now we have perf as a profiler inside autotest, which means one
can run autotest tests and have perf to profile the system while the
test is being run, so thank you guys for it :)

That said, I'm happy to help developing a test module for perf, be it
just a wrapper to an existing testsuite, or starting a new test module
from scratch. Let us know what you have in mind.

> 
> * http://autotest.github.com/


