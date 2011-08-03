Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1HCLhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:37:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58745 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938Ab1HCLhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:37:43 -0400
Date: Wed, 3 Aug 2011 13:37:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf sched: Fix list of events, dropping
 unsupported ':r' modifier
Message-ID: <20110803113706.GA5768@somewhere.redhat.com>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
 <tip-9710118bd4e7f3406865171cb9b9c94547c1c2f9@git.kernel.org>
 <1312369161.1147.292.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312369161.1147.292.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 12:59:21PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-01-14 at 07:25 +0000, tip-bot for Stephane Eranian wrote:
> > Looks to me like the :r modifier is not supported anymore, so remove it from
> > the list of events. 
> 
> acme, why is that anyway? -R is a fun way to save some typing, but not
> supporting :r anymore takes away the option of not getting
> PERF_SAMPLE_RAW output for every event.

Because it was very non obvious for people to select this -R or :r
every time they wanted to use trace events for tracing. I think
there was complaints about that. Moreover nobody seemed to use
trace events for non-tracing (perf report, top, annotate, ...)
so we decided to always have RAW records so that it works for
every cases...unless we lose events because of that.

We can still bring an option to force disabling of raw records.
