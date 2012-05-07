Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab2EGPwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:52:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47980 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab2EGPwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:52:05 -0400
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120507154412.GH18810@erda.amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
	 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
	 <1336395782.27020.37.camel@laptop>  <20120507154412.GH18810@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 May 2012 17:51:51 +0200
Message-ID: <1336405911.27020.70.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 17:44 +0200, Robert Richter wrote:
> On 07.05.12 15:03:02, Peter Zijlstra wrote:
> > On Wed, 2012-05-02 at 20:26 +0200, Robert Richter wrote:
> > > +enum ibs_filter_type {
> > > +       IBS_NO_FILTER           = 0,
> > > +       IBS_MATCH_FILTER        = 1,
> > > +       IBS_ANY_SET_FILTER      = 2,
> > > +       IBS_PSEUDO_EVENT        = 0x0F,
> > > +};
> > 
> > I don't get how those pseudo events work, AFAIKT IBS_PSEUDO_EVENT causes
> > one to loose all events since it does have a filter set but fails the
> > filter and thus we skip the call to perf_event_overflow().
> 
> You periodically (fix clk cycles or number of micro-ops) trigger IBS
> samples and afterwards analyses the samples for certain filter rules
> (see rule description in pmu-ibs.c). 

But IBS_PSEUDO_EVENT will fail all filter test and you'll end up with
exactly 0 samples. Still somewhat confused..

