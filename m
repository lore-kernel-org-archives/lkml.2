Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1ECPel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:34:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1ECPek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:34:40 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=FUIdUboL8ZEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8mR9c8h7AAAA:8 a=85MJgmNWUdD2r37VX5oA:9 a=PUjeQqilurYA:10 a=LdTqRQehjdcA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/4] x86, mce: Add persistent MCE event
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
In-Reply-To: <20110503152224.GG20241@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
	 <1304357691-14354-4-git-send-email-bp@amd64.org>
	 <20110503064401.GE7751@elte.hu> <20110503071833.GB18979@aftab>
	 <1304435656.1788.8.camel@Joe-Laptop>  <20110503152224.GG20241@aftab>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 May 2011 11:34:32 -0400
Message-ID: <1304436872.25414.2403.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 17:22 +0200, Borislav Petkov wrote:
> On Tue, May 03, 2011 at 11:14:16AM -0400, Joe Perches wrote:
> > On Tue, 2011-05-03 at 09:18 +0200, Borislav Petkov wrote:
> > > On Tue, May 03, 2011 at 02:44:01AM -0400, Ingo Molnar wrote:
> > > > * Borislav Petkov <bp@amd64.org> wrote:
> > []
> > > > > +static struct dentry *mce_add_event_debugfs(struct perf_event *event, int cpu)
> > > > > +{
> > > > > +	char buf[14];

There should be no harm in upping that number to 32. (I've seen much
worse on stacks).

> > > > > +
> > > > > +	sprintf(buf, "mce_record%d", cpu);

At least change this to:

		snprintf(buf, 14, ....)

> > 
> > trivia:
> > 
> > buf[14] doesn't fit 10k+ cpus.
> 
> I'll fix that when someone comes up with a x86 system that supports 10k+
> CPUs with a single system image :).
> 

Best to fix it now, to save the trouble of finding this bug for those
that are maintaining this code long after we have retired or are dead ;)

-- Steve



