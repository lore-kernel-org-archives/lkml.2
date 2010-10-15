Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab0JOVIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 17:08:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54206 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab0JOVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 17:08:33 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=L0fb2UCT-6QA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=E-KxaSNgd_uzVBB73v4A:9 a=OPD2p6rEhSBzFf8lJR0A:7 a=D_4bn7TW4o8-fuzg4FAD7HVFFLsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 8/9] jump label: Make arch_jump_label_text_poke_early()
 optional
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>, David Miller <davem@davemloft.net>,
        David Daney <ddaney@caviumnetworks.com>
In-Reply-To: <1287176815.1998.117.camel@laptop>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201037.703989993@goodmis.org>  <1287176815.1998.117.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 15 Oct 2010 17:08:30 -0400
Message-ID: <1287176910.16971.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 23:06 +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> > +
> > +#ifdef HAVE_ARCH_JUMP_LABEL_TEXT_POKE_EARLY
> >  extern void arch_jump_label_text_poke_early(jump_label_t addr);
> > +#else
> > +static inline void arch_jump_label_text_poke_early(jump_label_t addr) {}
> > +#endif
> > + 
> 
> How often is this called, do we really need to avoid that call? It looks
> like init code.

Yeah, that's a good point.

What's the harm in doing a stub in the mips code here?

-- Steve


