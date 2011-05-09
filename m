Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1EIMjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 08:39:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:46942 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1EIMjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 08:39:09 -0400
Date: Mon, 9 May 2011 14:39:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2 1/2] x86: skip migrating IRQF_PER_CPU irq in
 fixup_irqs
In-Reply-To: <20110506135828.GC5500@dumpdata.com>
Message-ID: <alpine.LFD.2.02.1105091437500.2843@ionos>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E2@shsmsx502.ccr.corp.intel.com> <20110506135828.GC5500@dumpdata.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011, Konrad Rzeszutek Wilk wrote:
> On Fri, May 06, 2011 at 02:43:36PM +0800, Tian, Kevin wrote:
> > because Xen event chip silently fails the set_affinity ops, and
> > logically IRQF_PER_CPU should be recognized here.
> 
> OK, so what if the set_affinity ops was implemented?

An interrupt chip which has a set_affinity op should not mark
something per cpu, which implies that the irq CANNOT be moved.

Thanks,

	tglx
