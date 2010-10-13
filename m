Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0JMPB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:01:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54988 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab0JMPBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A3Vp95pSz1kgR2EXNCRVZVEHaqS2IW86weVNeqYekhZDg4tv1E6o215ycG/4Efwxk0
         teeIA20bng3I6uptG2rTgN4C/AuCy9/eiFrNWZ8XF/RtUCe2az6zxvzvGQ2SknjoTWaA
         6TVt28SqSTqRWepCC25vvOw1cBl5ucZtpUUnc=
Date: Wed, 13 Oct 2010 17:01:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC PATCH 3/9] perf: Add ability to dump part of the user
	stack
Message-ID: <20101013150102.GE5335@nowhere>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> <1286946421-32202-4-git-send-regression-fweisbec@gmail.com> <1286954537.29097.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286954537.29097.59.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 09:22:17AM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-13 at 07:06 +0200, Frederic Weisbecker wrote:
> > +++ b/include/linux/perf_event.h
> > @@ -227,6 +227,12 @@ struct perf_event_attr {
> >         __u32                   bp_type;
> >         __u64                   bp_addr;
> >         __u64                   bp_len;
> > +
> > +       __u64                   __reserved_2;
> > +       __u64                   __reserved_3;
> > +
> > +       __u32                   ustack_dump_size;
> > +       __u32                   __reserved_4;
> >  }; 
> 
> Why add those two __u64 fields?


Because I suspect one day the breakpoint fields will need to be
extended. Some archs have quite fancy features for breakpoints
that include value comparison for example. So a field could be
used for the comparison operator and the other for the value
to be compared against.

