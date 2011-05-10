Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1EJD2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:28:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:63542 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1EJD2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:28:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,344,1301900400"; 
   d="scan'208";a="433364716"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Tue, 10 May 2011 11:26:54 +0800
Subject: RE: [PATCH v2 1/2] x86: skip migrating IRQF_PER_CPU irq in
 fixup_irqs
Thread-Topic: [PATCH v2 1/2] x86: skip migrating IRQF_PER_CPU irq in
 fixup_irqs
Thread-Index: AcwORhkDwgrHumEsTNGvPH7/QJgmywAe+drw
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8F008B6E@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E2@shsmsx502.ccr.corp.intel.com>
 <20110506135828.GC5500@dumpdata.com>
 <alpine.LFD.2.02.1105091437500.2843@ionos>
In-Reply-To: <alpine.LFD.2.02.1105091437500.2843@ionos>
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
> Sent: Monday, May 09, 2011 8:39 PM
> 
> On Fri, 6 May 2011, Konrad Rzeszutek Wilk wrote:
> > On Fri, May 06, 2011 at 02:43:36PM +0800, Tian, Kevin wrote:
> > > because Xen event chip silently fails the set_affinity ops, and
> > > logically IRQF_PER_CPU should be recognized here.
> >
> > OK, so what if the set_affinity ops was implemented?
> 
> An interrupt chip which has a set_affinity op should not mark something per
> cpu, which implies that the irq CANNOT be moved.
> 

If this is the hard requirement, why not throwing out an error when a chip
is registered?

Thanks
Kevin
