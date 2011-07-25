Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1GYKvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:51:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58876 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab1GYKu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:50:58 -0400
Date: Mon, 25 Jul 2011 12:50:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net,
        linux-kernel@vger.kernel.org, amodra@gmail.com
Subject: Re: [PATCH] perf: Fix symbol resolution on old ppc64 ABI
Message-ID: <20110725105004.GN28787@elte.hu>
References: <20110725142356.0c722c6b@kryten>
 <20110725062542.GA694@elte.hu>
 <20110725204859.51e50611@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725204859.51e50611@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Anton Blanchard <anton@samba.org> wrote:

> Hi Ingo,
> 
> > > The synthetic symbol creation code has an issue with the old ppc64 
> > > ABI. We end up with duplicate symbols of different sizes that 
> > > overlap.
> > > 
> > > To fix this, walk all of the symbols and remove any duplicates that 
> > > are the length of a function descriptor.
> > 
> > > I'd prefer not to add a ppc64 specific hack here, but I'm not sure 
> > > how we can fix this in a simpler way.
> > 
> > Symbol space problems are common on other architectures as well.
> > 
> > We could use a heuristic: when symbols are overlapping then we could 
> > throw away the one that is smaller. This would implicitly cover the 
> > ppc64 case, right?
> > 
> > I'd also suggest we warn somewhere that a symbol has been thrown 
> > away, if verbosity is turned off. (i.e. don't warn by default.)
> 
> It would cover most cases. There would be an issue with functions 
> that are less than 24 bytes in length (ie 6 instructions). Tiny 
> functions are probably rare enough that we can live with it.

Do such tiny functions get packed tightly, below 24 bytes? Another 
sanitization pass could solve that issue, to trim partially 
overlapping symbol regions, right?

Thanks,

	Ingo
