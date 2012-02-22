Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2BVOgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:36:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2BVOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:36:05 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=_aPKG9hbZygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=dzu5iA6h_c7mePG19JgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329921363.25686.100.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 09:36:03 -0500
In-Reply-To: <20120222142056.GA20040@Krystal>
References: <20120222065016.GA16923@elte.hu> <4F44934B.2000808@zytor.com>
	 <20120222072538.GA17291@elte.hu> <4F449ACF.3040807@zytor.com>
	 <20120222074839.GA24890@elte.hu>
	 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
	 <20120222080659.GA25318@elte.hu>
	 <1329916920.25686.79.camel@gandalf.stny.rr.com>
	 <20120222133404.GA14085@elte.hu>
	 <1329918881.25686.92.camel@gandalf.stny.rr.com>
	 <20120222142056.GA20040@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bike shed is getting really dark.

On Wed, 2012-02-22 at 09:20 -0500, Mathieu Desnoyers wrote:
>  
> [...]
> One possible naming that might be a good fit:
> 
> - read_always_likely()
> - read_always_unlikely()
> - read_always_branch()
> 
> I think it is important to convey both that it is expected to be always
> read, pretty much never updated, and the bias, or absence of bias.

That actually looks even more confusing. "read_always"? What the hell is
that?

> 
> I also _like_ to have a relatively long name here, because the update
> cost is so high that someone should really think before using this
> facility. In my opinion, it's not "just" a stronger likely/unlikely.

Then make it what it is (with a long name...)

	if (jump_label_likely())

	if (jump_label_unlikely())

That's probably the least confusing of the names. And for the cases we
don't care:

	if (jump_label_branch())

The above is the most descriptive and I would say the least confusing.
Someone on IRC said that they wish it had jump_label in the name. As
they see there's a "CONFIG_JUMP_LABEL" it tells us where those jump
labels are used.

Need to go and knock down the bike shed now.

-- Steve


