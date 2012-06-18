Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab2FRIqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:46:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:58459 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2FRIqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:46:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181434164"
From: "Ren, Yongjie" <yongjie.ren@intel.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
Thread-Topic: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI
 interrupts
Thread-Index: AQHNR7lbTzrrGB1m3kGBcjEcJOZmOpb0YmsAgAtridA=
Date: Mon, 18 Jun 2012 08:46:44 +0000
Message-ID: <1B4B44D9196EFF41AE41FDA404FC0A100F9FC8@SHSMSX101.ccr.corp.intel.com>
References: <1338570192.23475.25.camel@bling.home>
 <4FC8F867.7080103@siemens.com> <1338573558.23475.41.camel@bling.home>
 <4FC90961.8030701@siemens.com> <4FCB2359.9020505@redhat.com>
 <alpine.LFD.2.02.1206041235540.3086@ionos> <4FCC9EAC.9090007@siemens.com>
 <20120608143927.GA4949@redhat.com> <4FD21151.9090608@siemens.com>
 <4FD5C205.5070901@redhat.com> <20120611102139.GA31197@redhat.com>
In-Reply-To: <20120611102139.GA31197@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Michael S. Tsirkin [mailto:mst@redhat.com]
> Sent: Monday, June 11, 2012 6:22 PM
> To: Avi Kivity
> Cc: Jan Kiszka; Thomas Gleixner; Alex Williamson; kvm@vger.kernel.org;
> mtosatti@redhat.com; linux-kernel@vger.kernel.org; Ren, Yongjie
> Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI
> interrupts
> 
> On Mon, Jun 11, 2012 at 01:01:41PM +0300, Avi Kivity wrote:
> > On 06/08/2012 05:50 PM, Jan Kiszka wrote:
> > >
> > >>
> > >> Pls correct me if I'm wrong.
> > >
> > > Well, IIRC, the "don't loop over all vcpus with IRQs or preemption
> > > disabled" was one argument against direct legacy interrupt injection as
> > > well. That's what I kept in mind from those discussions. Maybe Avi can
> > > comment on the current position.
> >
> > It's still my position.
> >
> > IMO we need something like struct gfn_to_hva_cache for interrupts.  If
> > it's in the cache, we fast-path it from the interrupt handler.  If not,
> > fall back to a workqueue and let it refill the cache.
> 
> And you class the irqfd behaviour of injecting multicast
> with interrupts disabled a bug then?
> 
Hi Avi & Michael,
Any more news on this issue ?

> > --
> > error compiling committee.c: too many arguments to function
