Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2DPPsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:48:45 -0400
Received: from ocelot.phlegethon.org ([81.29.64.94]:54137 "EHLO
	mail.phlegethon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2DPPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:48:44 -0400
X-Greylist: delayed 1942 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 11:48:44 EDT
Date: Mon, 16 Apr 2012 16:16:13 +0100
From: Tim Deegan <tim@xen.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sheng Yang <sheng@yasker.org>
Subject: Re: [PATCH] xen: always set the sched clock as unstable
Message-ID: <20120416151613.GB13111@ocelot.phlegethon.org>
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com> <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F8C33E0.2080007@citrix.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 15:59 +0100 on 16 Apr (1334591984), David Vrabel wrote:
> On 16/04/12 12:32, Jan Beulich wrote:
> >>>> On 13.04.12 at 20:20, David Vrabel <david.vrabel@citrix.com> wrote:
> >> From: David Vrabel <david.vrabel@citrix.com>
> >>
> >> The sched clock was considered stable based on the capabilities of the
> >> underlying hardware.  This does not make sense for Xen PV guests as:
> >> a) the hardware TSC is not used directly as the clock source; and b)
> >> guests may migrate to hosts with different hardware capabilities.
> >>
> >> It is not clear to me whether the Xen clock source is supposed to be
> >> stable and whether it should be stable across migration.  For a clock
> >> source to be stable it must be: a) monotonic; c) synchronized across
> >> CPUs; and c) constant rate.
> 
> Tim, Thomas, can you comment on the above paragraph?  Is it correct?

How synchronized does it need to be?  The adjustment of the rate happens
independently on different CPUs so you might be able to see small
differences if once CPU has made the adjustment but another hasn't yet.

That aside, on platforms where the real TSC is stable, AFAIK the xen PV
time will be too, _except_ across migration.  I have no idea whether Xen
exports sufficient information to the guest for it to be able to tell
whether this is the case, though -- it needs to know not only that the
hardware is stable, but thet _Xen_ thinks it's stable.

Across migration, the PV time might not be monotonic (because it's always
the wallclock time on the current host, not a VM-specific attribute).
Which is not to say that the linux-side code couldn't make it monotonic,
at least for small differences between hosts. 

Tim.
