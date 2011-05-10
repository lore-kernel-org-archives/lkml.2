Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab1EJDYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:24:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:5504 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab1EJDYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:24:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,344,1301900400"; 
   d="scan'208";a="433363161"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Tue, 10 May 2011 11:24:22 +0800
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Topic: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Index: AcwORc6McB5lwtD3QfS40WLCK7YIiAAe45Og
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8F008B68@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <alpine.LFD.2.02.1105061149330.3005@ionos>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7FB9F@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1105091301040.10886@kaball-desktop>
 <alpine.LFD.2.02.1105091435350.2843@ionos>
In-Reply-To: <alpine.LFD.2.02.1105091435350.2843@ionos>
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

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Monday, May 09, 2011 8:37 PM
> 
> On Mon, 9 May 2011, Stefano Stabellini wrote:
> 
> > On Mon, 9 May 2011, Tian, Kevin wrote:
> > > yes, with your patch this issue disappears, since you explicitly
> > > make mask/unmask as a nop for xen_percpu_chip, which effectively
> > > avoids them from undesired unmask when doing the migration. Though
> > > it works, it's not intuitive as to me it's an workaround to make Xen chip
> implementation adapting to specific fixup_irqs logic.
> >
> > I have been tring to follow the example of existing supported drivers.
> > The only x86 driver I could find that uses handle_percpu_irq is uv_irq
> > that does exatly the same thing.
> 
> Which is a good enough argument to make that change at the common code
> level instead of having fancy workarounds here and there.
> 

So Thomas, what's your suggestion to continue here? Is my original patch to skip
percpu irq in common code a good option to go, or you want a cleaner code in 
other form? Once it's clear I'll discuss with Stefano e.g. possibly merge with his
cleanup patch series. :-)

Thanks
Kevin
