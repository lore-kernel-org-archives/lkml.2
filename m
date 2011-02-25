Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab1BYW3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:29:06 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47186 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817Ab1BYW3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:29:05 -0500
Date: Fri, 25 Feb 2011 16:29:00 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: Performance/resume issues on Toshiba NB305
Message-ID: <20110225222900.GD24686@thinkpad-t410>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
References: <20110225164239.GA24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6>
 <20110225212142.GC24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 10:47:16PM +0100, Thomas Gleixner wrote:
> Let's wait for the intel and acpi folks. It would be interesting what
> the new intel toy says to your BIOS.
> 
>     http://biosbits.org/

Not much because it doesn't know about my processor. About all I could
get out of it is that my MSRs are inconsistent, SMI latency is bad, and
the round-trip latency via MWAIT test gives elapsed time = 285ms with
229 iterations/ms.

> > Then there must be a bug. When I cleared CLOCK_EVT_FEAT_ONESHOT for the
> > HPET without this change the HPET got put into oneshot mode. The local
> > tick device is checked before switching to nohz, but not the broadcast
> > device. This change was just a quick hack to get around that and test my
> > theory.
> 
> Indeed. The patch below should cure that.

It works. I was wondering whether or not I should put the broadcast
device in periodic mode with the local ones in nohz; I guess your patch
answers my question.

> 
> Thanks,
> 
> 	tglx
> 
> ----------->
> Subject: clockevents-fix-broadcast.patch
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 25 Feb 2011 22:34:23 +0100
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Tested-by: Seth Forshee <seth.forshee@canonical.com>

