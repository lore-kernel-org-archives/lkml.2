Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab1BYWks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:40:48 -0500
Received: from www.tglx.de ([62.245.132.106]:41748 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab1BYWkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:40:47 -0500
Date: Fri, 25 Feb 2011 23:40:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>,
        Burt Triplett <burt@pbjtriplett.org>
Subject: Re: Performance/resume issues on Toshiba NB305
In-Reply-To: <20110225222900.GD24686@thinkpad-t410>
Message-ID: <alpine.LFD.2.00.1102252330290.2701@localhost6.localdomain6>
References: <20110225164239.GA24686@thinkpad-t410> <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6> <20110225212142.GC24686@thinkpad-t410> <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6> <20110225222900.GD24686@thinkpad-t410>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Seth Forshee wrote:

> On Fri, Feb 25, 2011 at 10:47:16PM +0100, Thomas Gleixner wrote:
> > Let's wait for the intel and acpi folks. It would be interesting what
> > the new intel toy says to your BIOS.
> > 
> >     http://biosbits.org/
> 
> Not much because it doesn't know about my processor. About all I could
> get out of it is that my MSRs are inconsistent, SMI latency is bad, and
> the round-trip latency via MWAIT test gives elapsed time = 285ms with
> 229 iterations/ms.

Ouch.
 
> > > Then there must be a bug. When I cleared CLOCK_EVT_FEAT_ONESHOT for the
> > > HPET without this change the HPET got put into oneshot mode. The local
> > > tick device is checked before switching to nohz, but not the broadcast
> > > device. This change was just a quick hack to get around that and test my
> > > theory.
> > 
> > Indeed. The patch below should cure that.
> 
> It works. I was wondering whether or not I should put the broadcast
> device in periodic mode with the local ones in nohz; I guess your patch
> answers my question.

Well, there is no point having the local ones in nohz mode when
broadcast one does not support it. You only get power saving when your
box stays in deep power modes for a long time. So with the BC periodic
it will try to go into deep power states (not knowing about the
periodic BC issue) and pop out of it in the same way as you do with
nohz disabled. So the power saving effect is approx. zero.

Thanks,

	tglx
