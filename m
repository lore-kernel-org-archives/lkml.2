Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab2GZFu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:50:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab2GZFu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:50:27 -0400
Date: Thu, 26 Jul 2012 08:50:11 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Message-ID: <20120726055011.GP26120@redhat.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120723181358.GC6717@infradead.org>
 <500EAF23.8060909@gmail.com>
 <20120724161507.GG3732@erda.amd.com>
 <1343248546.26034.68.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343248546.26034.68.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 10:35:46PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-07-24 at 18:15 +0200, Robert Richter wrote:
> > David,
> > 
> > On 24.07.12 08:20:19, David Ahern wrote:
> > > On 7/23/12 12:13 PM, Arnaldo Carvalho de Melo wrote:
> > > > Em Fri, Jul 20, 2012 at 05:25:53PM -0600, David Ahern escreveu:
> > > >> PEBS cannot be used with guest mode. If user adds :p modifier set
> > > >> exclude_guest as well.
> > > >
> > > > Is this something Intel specific? Or can someone think of an arch where
> > > > this limitation wouldn't exist?
> > > 
> > > Good point. So far precise_ip is used by arch/x86 only. I don't have an 
> > > AMD based server so I don't know if there is a conflict between 
> > > virtualization and IBS. Added Robert for advice.
> > 
> > thanks for this hint.
> > 
> > On AMD cpus precise_ip maps to IBS, which does not support hardware
> > options as perfctrs do. Thus, following attr flags are not supported:
> > 
> >  exclude_user, exclude_kernel, exclude_host, exclude_guest
> > 
> > Counting in guest mode is possible with IBS, but not the exclusion of
> > a certain mode. If precise_ip counting is enabled on AMD we may not
> > set the exclude_guest flag.
> 
> IIRC we have SVM enter/exit hooks in kvm/perf already, we could use
> those to implement exclude_guest for IBS.
> 
> Now I've been trying to find the patches that introduced that, but I'm
> failing horridly. Gleb, got us a pointer here?
The commit is 144d31e6, but it introduces hook that is used on VMX only.
SVM does not need it to implement guest/host only counters since it
has HW support for that in the PMU.
 
--
			Gleb.
