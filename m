Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab1GREH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 00:07:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:45245 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab1GREHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 00:07:54 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        paulus@samba.org, tglx@linutronix.de, walken@google.com,
        dhowells@redhat.com, cmetcalf@tilera.com, tony.luck@intel.com,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310961196.25044.266.camel@pasglop>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop>  <1310944453.25044.262.camel@pasglop>
	 <1310961196.25044.266.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 14:02:23 +1000
Message-ID: <1310961743.25044.275.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 13:53 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2011-07-18 at 09:14 +1000, Benjamin Herrenschmidt wrote:
> 
> > In fact, with such a flag, we could probably avoid the ifdef entirely, and
> > always go toward the PTE fixup path when called in such a fixup case, my gut
> > feeling is that this is going to be seldom enough not to hurt x86 measurably
> > but we'll have to try it out.
> > 
> > That leads to that even less tested patch:
> 
>  And here's a version that builds (still not tested :-)
> 
> Shan, can you verify whether that fixes the problem for you ?
> 
> I also had a cursory glance at the ARM code and it seems to rely on the
> same stuff as embedded powerpc does for dirty/young updates, so in
> theory it should exhibit the same problem.
> 
> I suspect the scenario is rare enough in practice in embedded workloads
> that nobody noticed until now.

Ignore that bogus send, I sent a proper one immediately after (evolution
FAIL, sorry about that)

Cheers,
Ben.


