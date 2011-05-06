Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1EFVnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:43:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:10376 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab1EFVnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:43:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="689287428"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Sat, 7 May 2011 05:43:12 +0800
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Topic: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Index: AcwL+bTQLIdKuFPJQSKYXmpwNiVr0QAPNbiw
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F99D@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <alpine.LFD.2.02.1105061149330.3005@ionos>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stefano Stabellini [mailto:stefano.stabellini@eu.citrix.com]
> Sent: Friday, May 06, 2011 10:29 PM
> 
> On Fri, 6 May 2011, Tian, Kevin wrote:
> > > From: Thomas Gleixner
> > > Sent: Friday, May 06, 2011 6:00 PM
> > >
> > > On Fri, 6 May 2011, Tian, Kevin wrote:
> > > > x86: don't unmask disabled irqs when migrating them
> > > >
> > > > it doesn't make sense to mask/unmask a disabled irq when migrating
> > > > it from offlined cpu to another, because it's not expected to
> > > > handle any instance of it. Current mask/set_affinity/unmask steps
> > > > may trigger unexpected instance on disabled irq which then simply
> > > > bug on when there is no handler for it. One failing example is observed in
> Xen.
> > > > Xen pvops
> > >
> > > So there is no handler, why the heck is there an irq action?
> > >
> > > 	  if (!irq_has_action(irq) ....
> > > 	     	continue;
> > >
> > > Should have caught an uninitialized interrupt. If Xen abuses
> > > interrupts that way, then it rightfully explodes. And we do not fix it by magic
> somewhere else.
> >
> > sorry that my bad description here. there does be a dummy handler
> > registered on such irqs which simply throws out a BUG_ON when hit. I
> > should just say such injection is not expected instead of no handler.
> > :-)
> 
> I don't think this patch is necessary anymore after the event channel handling
> cleanup patches I have just sent to the list.
> Could you please try the following two patches:
> 
> http://marc.info/?l=linux-kernel&m=130468120032172&w=2
> http://marc.info/?l=linux-kernel&m=130468178200468&w=2
> 
> and let me know if you still need this patch?

thanks, and I'll take a look at them.

Thanks
Kevin
