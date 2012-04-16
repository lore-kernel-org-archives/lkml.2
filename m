Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2DPQVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:21:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49844 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab2DPQVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:21:03 -0400
MIME-Version: 1.0
Message-ID: <cab53fa9-398f-4e06-885f-c388a9ea3c29@default>
Date: Mon, 16 Apr 2012 09:20:26 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Cc: "Tim (Xen.org)" <tim@xen.org>, linux-kernel@vger.kernel.org,
        xen-devel <xen-devel@lists.xen.org>, Jan Beulich <JBeulich@suse.com>,
        Sheng Yang <sheng@yasker.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
 <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com>
 <20120416151759.GI1903@phenom.dumpdata.com>
In-Reply-To: <20120416151759.GI1903@phenom.dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F8C46DE.00A7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
> 
> On Mon, Apr 16, 2012 at 03:59:44PM +0100, David Vrabel wrote:
> > On 16/04/12 12:32, Jan Beulich wrote:
> > >>>> On 13.04.12 at 20:20, David Vrabel <david.vrabel@citrix.com> wrote:
> > >> From: David Vrabel <david.vrabel@citrix.com>
> > >>
> > >> The sched clock was considered stable based on the capabilities of the
> > >> underlying hardware.  This does not make sense for Xen PV guests as:
> 
> In regards to PV dom0 is this still the case? Asking b/c your
> patch will make dom0 be in the same category.
> 
> > >> a) the hardware TSC is not used directly as the clock source; and b)
> > >> guests may migrate to hosts with different hardware capabilities.
> > >>
> > >> It is not clear to me whether the Xen clock source is supposed to be
> > >> stable and whether it should be stable across migration.  For a clock

Xen is -- and has always been -- responsible for emulating sufficient
clock hardware devices and presenting them to the guest AND ensuring
that this emulation works properly across migration/save/restore (which
is required because these transitions may be completely transparent
to the guest).

Prior to Xen 4.0, TSC was not considered to be a clocksource worthy
of emulating and was passed through to PV guests unchanged (and not
fully handled for HVM either IIRC).  At Xen 4.0+, it is handled properly.
 
> I thought it was dependent on XEN_DOMCTL_settscinfo:
>  - whether it gets emulated, or the guest can do rdtsc or pvrdtsc?
>
> Which I think is determined by some 'timer=X' option in the guest config?

I think you may be thinking of tsc_mode.  See docs/misc/tscmode.txt
in the Xen source.  The default should work correctly.

