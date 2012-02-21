Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab2BUVQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 16:16:24 -0500
Received: from mail.openrapids.net ([64.15.138.104]:48709 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752424Ab2BUVQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 16:16:23 -0500
Date: Tue, 21 Feb 2012 16:16:17 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mingo@elte.hu, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
	+ docs
Message-ID: <20120221211617.GB15210@Krystal>
References: <cover.1329851692.git.jbaron@redhat.com> <4F43F9F0.4000605@zytor.com> <20120221202019.GB2381@redhat.com> <1329856745.25686.72.camel@gandalf.stny.rr.com> <4F440857.6010907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F440857.6010907@zytor.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:13:14 up 455 days,  2:16,  2 users,  load average: 0.02, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> On 02/21/2012 12:39 PM, Steven Rostedt wrote:
> > On Tue, 2012-02-21 at 15:20 -0500, Jason Baron wrote:
> > 
> >> I'm not really too hung up on the naming, but I did think that
> >> very_[un]likely were an interesting possibility.
> > 
> > The problem comes from what Peter said. They are too similar to
> > "likely()" and "unlikely()", and can become confusing.
> > 
> > Maybe "static_likely()" and "static_unlikely()" as the word "static" can
> > imply something strange about these. Or perhaps a "const_likely()"?
> > 
> > Maybe "dynamic_branch_true()" and "dynamic_branch_false()". This may be
> > the most descriptive.
> > 
> 
> I thought about this some more, and the very_[un]likely() naming is even
> worse than I originally thought: the jump label stuff isn't about the
> bias level, but rather if a static decision (on the order or once per
> boot) can be made to go one way or the other.
> 
> 	-hpa

I agree that this decision is taken typically once at boot time, so
claiming it is only a strong compiler bias hint for block placement
would be a lie. However, I think the fact that the fall-through is for
either true or false branch seems to be an implicit bias. Therefore, I
start to like the static_likely()/static_unlikely(), which conveys both
the static nature of the branch, as well as the bias.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
