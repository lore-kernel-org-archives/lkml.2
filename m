Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab0GGOKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:10:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47243 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207Ab0GGOKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:10:21 -0400
Date: Wed, 7 Jul 2010 16:10:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Gleb Natapov <gleb@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: KVM, fix lock imbalance
Message-ID: <20100707141008.GA7419@elte.hu>
References: <1278507745-32746-1-git-send-email-jirislaby@gmail.com>
 <20100707130545.GA14934@elte.hu>
 <4C347C0E.6020107@gmail.com>
 <4C347F3C.2010704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C347F3C.2010704@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 07/07/2010 04:07 PM, Jiri Slaby wrote:
> >
> >>A cleanliness comment: why is that tear-down/dealloc sequence open-coded? It
> >>should be at the end of the function, with goto labels, like we do it in
> >>similar cases.
> >Because the lock is around a block only. I usually don't create a goto
> >fail-paths in these cases. Do you want one?
> 
> In any case, the patch is a minimal fix, so I'll apply it.  Any clean ups 
> can go on top.

The reason the pattern caught my attention is that it is one of the typical 
cases where goto labels help prevent similar bugs. I.e. had it been clean to 
begin with the bug might not have happened.

Thanks,

	Ingo
