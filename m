Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2BVIHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:07:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40530 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2BVIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:07:17 -0500
Date: Wed, 22 Feb 2012 09:06:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222080659.GA25318@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120222065016.GA16923@elte.hu>
 <4F44934B.2000808@zytor.com>
 <20120222072538.GA17291@elte.hu>
 <4F449ACF.3040807@zytor.com>
 <20120222074839.GA24890@elte.hu>
 <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Not arguing that, but the static aspect is still key... or 
> people will read it as another version of likely/unlikely.  

They can *read* it as such, that as is very much intentional! 

People reading such code should indeed treat it as a branch 
probability attribute (and ignore it in 99.9% of the cases).

The moment they *write* static_cond_slow_inc() in real code 
though they will be warned about the speciality and slowness of 
the update path. More so than they are warned by the current 
jump_label_inc() name, me thinks.

> I'd be fine with static_likely/unlikely for example; I wish 
> "static" wasn't such an overloaded word in C but I 
> can't.personally think of a better term.

Yeah, we considered static_likely()/unlikely() but it is indeed 
overloaded *way* too much, so we went for 
very_likely()/very_unlikely() which also fairly conveys the real 
meaning at the usage site ...

I think the naming scheme I suggested in the other mail 
sufficienty carries both the attribute, bias and update cost 
aspects.

Thanks,

	Ingo
