Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1EBPGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:06:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49908 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab1EBPGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:06:05 -0400
Date: Mon, 2 May 2011 17:05:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] x86, x2apic: minimize IPI register writes using
 cluster groups v4
Message-ID: <20110502150552.GA21974@elte.hu>
References: <20110502113445.751391656@openvz.org>
 <20110502114024.222582172@openvz.org>
 <20110502132232.GA3873@elte.hu>
 <4DBEB96A.8000309@openvz.org>
 <4DBEBE72.3040702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBEBE72.3040702@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On 05/02/2011 06:02 PM, Cyrill Gorcunov wrote:
> ...
> > 
> >   Ingo, the idea was to merge probe_x.c completely, and put all this not into init()
> > but rather into apic->probe() or something like that. I don't have a clear picture
> > in mind yet what the best way would be, so instead of fast designed method I thought
> > to leave it opencoded with fixme note.
> > 
> >   So lets wait until Suresh post the benchmark and I will make apic->init() meanwhile.
> > 
> 
>   Ingo, would it be fine to make apic->init() either _before_ this series or 
> on top of them (because if I introduce it inside this particular patch it 
> would contain some unrelated code snippets such as .init = NULL for all apics 
> declaration).

Of course it should be a separate patch - even this patch looks a bit large - 
any way to split it up further?

And yes, if it fits it should be in apic->probe() instead of introducing a new 
->init() method.

Thanks,

	Ingo
