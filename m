Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0H0Ukr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 16:40:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:40579 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0H0Uko convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 16:40:44 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: Serious problem with ticket spinlocks on ia64
Date: Fri, 27 Aug 2010 22:41:14 +0200
User-Agent: KMail/1.9.10
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hedi Berriche <hedi@sgi.com>
References: <201008271537.35709.ptesarik@suse.cz> <987664A83D2D224EAE907B061CE93D53015D91D029@orsmsx505.amr.corp.intel.com> <987664A83D2D224EAE907B061CE93D53015D91D3B7@orsmsx505.amr.corp.intel.com>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53015D91D3B7@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <201008272241.15735.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 of August 2010 22:29:41 Luck, Tony wrote:
> > If this is a memory ordering problem (and that seems quite plausible)
> > then a liberal sprinkling of "ia64_mf()" calls throughout the spinlock
> > routines would probably make it go away.
>
> I think I take this back ... if it were a memory ordering problem, then
> it could show up any time - not just at wrap-around.

Well, I wasn't originally sure if it only happens at wrap-around. OTOH I've 
now modified my tests, so that they would also catch any other badness, and I 
still only got another two failures after wrap-around.

>From looking at the traces, I'm afraid this smells like another Itanium 
erratum. I'm now trying to write a minimal test case...

Petr Tesarik
