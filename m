Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1GYKtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:49:14 -0400
Received: from ozlabs.org ([203.10.76.45]:41324 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab1GYKtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:49:03 -0400
Date: Mon, 25 Jul 2011 20:48:59 +1000
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, emunson@mgebm.net,
        linux-kernel@vger.kernel.org, amodra@gmail.com
Subject: Re: [PATCH] perf: Fix symbol resolution on old ppc64 ABI
Message-ID: <20110725204859.51e50611@kryten>
In-Reply-To: <20110725062542.GA694@elte.hu>
References: <20110725142356.0c722c6b@kryten>
	<20110725062542.GA694@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> > The synthetic symbol creation code has an issue with the old ppc64 
> > ABI. We end up with duplicate symbols of different sizes that 
> > overlap.
> > 
> > To fix this, walk all of the symbols and remove any duplicates that 
> > are the length of a function descriptor.
> 
> > I'd prefer not to add a ppc64 specific hack here, but I'm not sure 
> > how we can fix this in a simpler way.
> 
> Symbol space problems are common on other architectures as well.
> 
> We could use a heuristic: when symbols are overlapping then we could 
> throw away the one that is smaller. This would implicitly cover the 
> ppc64 case, right?
> 
> I'd also suggest we warn somewhere that a symbol has been thrown 
> away, if verbosity is turned off. (i.e. don't warn by default.)

It would cover most cases. There would be an issue with functions that
are less than 24 bytes in length (ie 6 instructions). Tiny functions
are probably rare enough that we can live with it.

Anton
