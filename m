Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1CBKgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:36:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40123 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab1CBKgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:36:41 -0500
Date: Wed, 2 Mar 2011 11:36:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86/mm] x86-64, NUMA: Fix distance table handling
Message-ID: <20110302103631.GA25608@elte.hu>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302100727.GA24692@elte.hu>
 <20110302101547.GA3319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302101547.GA3319@htj.dyndns.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> FWIW, I'm not really decided about 80 vs. whatever column issue.

It only really matters when the underlying code structure is clearly inefficient: 
too many indentations, etc.

but printks or function calls that go beyond 80 cols a bit do not deserve to be 
line-broken.

> Having a common limit definitely helps a lot but it seems almost
> impossible to agree on one - is it 90, 95, 100 or 120?  Given that, it
> almost seems just sticking to 80 might be the only doable solution.

The problem is that many sensible code structures break with a limit of 80.

So i'd suggest being permissive when the code is fine (printks, function calls at 
the first or second level of indentation, etc.) and being conservative when the 
underlying code is not fine.

Thanks,

	Ingo
