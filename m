Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab1EQNCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:02:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:40604 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab1EQNCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:02:50 -0400
Date: Tue, 17 May 2011 15:02:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "steiner@sgi.com" <steiner@sgi.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>
Subject: Re: [patch 1/5] x84_64, apic: Use probe routines to simplify apic
 selection
In-Reply-To: <20110517122836.GA14758@elte.hu>
Message-ID: <alpine.LFD.2.02.1105171502190.3078@ionos>
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com> <20110513181008.859892593@sbsiddha-MOBL3.sc.intel.com> <20110516080844.GC27635@elte.hu> <1305589908.13584.3.camel@sbsiddha-MOBL3.sc.intel.com> <20110517122836.GA14758@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > On Mon, 2011-05-16 at 01:08 -0700, Ingo Molnar wrote:
> > > Ok, looks like a step forward in the right direction.
> > > 
> > > Wouldnt it be more self-contained if the probe function returned an apic driver 
> > > pointer?
> > > 
> > > We could add an __apicdriver section trick to 'know' about all APIC probing 
> > > functions - and we'd call them one by one and use the first one that returns a 
> > > non-NULL result.
> > > 
> > > Then we'd have the generic fallback APIC drivers as well - not marked 
> > > __apicdriver but used by the probe function directly.
> > > 
> > > Or we could have them as __apicdriver as well, but then the .o link ordering 
> > > matters to probing order.
> > > 
> > 
> > So how does something like the appended look? There are multiple apic
> > driver routines and apic name string that is being looked at by the
> > generic code. So I exported the struct apic * using the section trick.
> > 
> > Untested for now. If you are ok, then I will post with a better
> > changelog.
> 
> Yeah, this looks very nice to me.

Ditto.
