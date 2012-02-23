Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2BWXSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:18:46 -0500
Received: from mail.openrapids.net ([64.15.138.104]:40318 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756141Ab2BWXSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:18:45 -0500
Date: Thu, 23 Feb 2012 18:18:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, davem@davemloft.net, ddaney.cavm@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
	+ docs
Message-ID: <20120223231842.GA31030@Krystal>
References: <1329856745.25686.72.camel@gandalf.stny.rr.com> <20120222073251.GB17291@elte.hu> <20120222075334.GA25053@elte.hu> <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com> <20120222081855.GB25318@elte.hu> <20120222213343.GA19758@bloggs.ozlabs.ibm.com> <20120223100205.GD24310@elte.hu> <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com> <20120223223348.GA25513@elte.hu> <20120223223933.GA7942@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223223933.GA7942@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:08:43 up 457 days,  4:11,  5 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > So, a modified scheme would be:
> > 
> >         #include <linux/static_key.h>
> > 
> >         struct static_key key = STATIC_KEY_INIT_TRUE;
> > 
> >         if (static_key_false(&key))
> >                 do unlikely code
> >         else
> >                 do likely code
> > 
> > Or:
> > 
> >         if (static_key_true(&key))
> >                 do likely code
> >         else
> >                 do unlikely code
> > 
> > The static key is modified via:
> > 
> >         static_key_slow_inc(&key);
> >         ...
> >         static_key_slow_dec(&key);
> > 
> > Is that API fine? I'll rework the series to such an effect if 
> > everyone agrees.
> 
> I.e. something like the patch below on top of 
> tip:perf/jump-labels.
> 
> Untested - will test it and will refactor the series if 
> everyone's happy.

Hi Ingo,

Reading your documentation updates makes me realise that adding the
"inline" keyword in there would make the whole thing even clearer:

struct static_key key = STATIC_KEY_INLINE_TRUE_INIT;
struct static_key key = STATIC_KEY_INLINE_FALSE_INIT;

static_key_inline_true() / static_key_inline_false()

to show that the "true/false" in there does not mean that the key will
always be true or false (the key value can indeed by changed by calling
static_key_slow_inc/dec), but that the inlined path is either the true
of false branch.

The rest looks fine.

Best regards,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
