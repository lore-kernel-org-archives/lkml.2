Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2DQPnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:43:20 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33238 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2DQPnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:43:19 -0400
MIME-Version: 1.0
Message-ID: <3ea2625c-bbf0-44ad-9047-ecc3b8bce29f@default>
Date: Tue, 17 Apr 2012 08:42:48 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, xen-devel <xen-devel@lists.xen.org>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        "Tim (Xen.org)" <tim@xen.org>, Sheng Yang <sheng@yasker.org>
Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
 <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com>
 <049b7b93-fb37-4962-b272-d786e1dcfacb@default> <4F8C4818.8070603@citrix.com>
 <8a78da52-26b2-42a2-80c7-c1ab8aee86eb@default>
 <4F8D3C4E020000780007E658@nat28.tlf.novell.com>
In-Reply-To: <4F8D3C4E020000780007E658@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090201.4F8D8F84.00F2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jan Beulich [mailto:JBeulich@suse.com]
> Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
> 
> >>> On 16.04.12 at 19:30, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> >>  From: David Vrabel [mailto:david.vrabel@citrix.com]
> >> Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
> >>
> >> On 16/04/12 17:05, Dan Magenheimer wrote:
> >> >> From: David Vrabel [mailto:david.vrabel@citrix.com]
> >> >> Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
> >> >
> >> > Nacked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> >>
> >> Fair enough,
> >>
> >> > [A stable clock] should be true for Xen 4.0+ (but not for pre-Xen-4.0).
> >>
> >> The original customer problem is on a host with Xen 3.4.  What do you
> >> recommend for Linux guests running such hosts?
> >
> > For pre-Xen-4.0 and an unchanged PV guest, I don't know.  If you can
> > back-patch the guest kernel with a workaround such as your patch, great!
> > I'm only arguing against the patch getting perpetuated upstream.
> >
> >> > In fact, it might be wise for a Xen-savvy kernel to check to see
> >> > if it is running on Xen-4.0+ and, if so, force clocksource=tsc
> >> > and tsc=reliable.
> >>
> >> So, should the xen clocksource do:
> >>
> >> if Xen 4.0+
> >>     clock is stable, use rdtsc only.
> >> else
> >>     clock is unstable, use existing pvclock implementation.
> >
> > Yes, that's what I propose.  To clarify:
> >
> > if the guest can and does determine it is running on Xen 4.0+
> 
> _and_ TSC reads are emulated (which I don't think they are by
> default

They are emulated by default on any machine where Xen has
determined that TSC is untrustworthy AND always after migration.
So by definition (if not always in fact, see previous email),
and ignoring Xen bugs, Xen 4.0+ guarantees to guests that TSC
is a stable clock across all vcpus.
