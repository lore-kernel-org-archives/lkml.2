Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab2GNMdJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 08:33:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:47955 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab2GNMdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:33:07 -0400
Date: Sat, 14 Jul 2012 14:33:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
In-Reply-To: <500156B3.6040205@web.de>
Message-ID: <alpine.LFD.2.02.1207141402290.32033@ionos>
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com> <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com> <alpine.LFD.2.02.1207131928000.32033@ionos> <alpine.LFD.2.02.1207140208270.32033@ionos>
 <500118F1.8060300@web.de> <alpine.LFD.2.02.1207141253490.32033@ionos> <500156B3.6040205@web.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2012, Jan Kiszka wrote:
> On 2012-07-14 13:16, Thomas Gleixner wrote:
> > On Sat, 14 Jul 2012, Jan Kiszka wrote:
> >> On 2012-07-14 04:25, Thomas Gleixner wrote:
> >> This patch here is a workaround to unbreak devices assignment in 3.5
> >> after the IRQ layer changes without regressing noticeable /wrt overhead.
> > 
> > Yeah, workaround and regression are the proper marketing buzzwords to
> > excuse mindless hackery.
> > 
> > It took me a minute to figure out that there is no reason at all to
> > use a threaded interrupt handler for MSI and MSIX.
> 
> Thomas, we also explained to you in the cited thread that your simple
> approach for this doesn't work as is. We will have a proper solution
> soon, but it takes a bit more than a minute - at least us.

And I explained to you in that very thread that the proper solution to
avoid the "overhead" of finalize_oneshot is exaclty the patch I sent
to Linus yesterday:

> The only way we can avoid that, is that we get a hint from the
> underlying irq chip/ handler setup with an extra flag to tell the
> core, that it's safe to avoid the ONESHOT/finalize magic.

So now it took a full month of ignorance to come up with the
mindboggling solution of working around the core change with a private
hack instead of sitting down and doing what was said to be the correct
solution.

And that's what seriously annoys me. Instead of doing it yourself or
at least politely poking me to get it done, stuff just gets hacked
into submission and sold as the "performance regression" saviour.

Of course you are free to ignore my advice, but that does not mean
that I take bullshit from you.

Thanks,

	tglx
