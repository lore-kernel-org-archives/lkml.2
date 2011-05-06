Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab1EFO1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 10:27:17 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:33057 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1EFO1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 10:27:16 -0400
X-IronPort-AV: E=Sophos;i="4.64,326,1301875200"; 
   d="scan'208";a="5639306"
Date: Fri, 6 May 2011 15:28:38 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com> <alpine.LFD.2.02.1105061149330.3005@ionos> <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011, Tian, Kevin wrote:
> > From: Thomas Gleixner
> > Sent: Friday, May 06, 2011 6:00 PM
> > 
> > On Fri, 6 May 2011, Tian, Kevin wrote:
> > > x86: don't unmask disabled irqs when migrating them
> > >
> > > it doesn't make sense to mask/unmask a disabled irq when migrating it
> > > from offlined cpu to another, because it's not expected to handle any
> > > instance of it. Current mask/set_affinity/unmask steps may trigger
> > > unexpected instance on disabled irq which then simply bug on when
> > > there is no handler for it. One failing example is observed in Xen.
> > > Xen pvops
> > 
> > So there is no handler, why the heck is there an irq action?
> > 
> > 	  if (!irq_has_action(irq) ....
> > 	     	continue;
> > 
> > Should have caught an uninitialized interrupt. If Xen abuses interrupts that way,
> > then it rightfully explodes. And we do not fix it by magic somewhere else.
> 
> sorry that my bad description here. there does be a dummy handler registered
> on such irqs which simply throws out a BUG_ON when hit. I should just say such 
> injection is not expected instead of no handler. :-)

I don't think this patch is necessary anymore after the event channel
handling cleanup patches I have just sent to the list.
Could you please try the following two patches:

http://marc.info/?l=linux-kernel&m=130468120032172&w=2
http://marc.info/?l=linux-kernel&m=130468178200468&w=2

and let me know if you still need this patch?
