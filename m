Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1EQM2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:28:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50228 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1EQM2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:28:51 -0400
Date: Tue, 17 May 2011 14:28:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "steiner@sgi.com" <steiner@sgi.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>
Subject: Re: [patch 1/5] x84_64, apic: Use probe routines to simplify apic
 selection
Message-ID: <20110517122836.GA14758@elte.hu>
References: <20110513180449.562138524@sbsiddha-MOBL3.sc.intel.com>
 <20110513181008.859892593@sbsiddha-MOBL3.sc.intel.com>
 <20110516080844.GC27635@elte.hu>
 <1305589908.13584.3.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305589908.13584.3.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Mon, 2011-05-16 at 01:08 -0700, Ingo Molnar wrote:
> > Ok, looks like a step forward in the right direction.
> > 
> > Wouldnt it be more self-contained if the probe function returned an apic driver 
> > pointer?
> > 
> > We could add an __apicdriver section trick to 'know' about all APIC probing 
> > functions - and we'd call them one by one and use the first one that returns a 
> > non-NULL result.
> > 
> > Then we'd have the generic fallback APIC drivers as well - not marked 
> > __apicdriver but used by the probe function directly.
> > 
> > Or we could have them as __apicdriver as well, but then the .o link ordering 
> > matters to probing order.
> > 
> 
> So how does something like the appended look? There are multiple apic
> driver routines and apic name string that is being looked at by the
> generic code. So I exported the struct apic * using the section trick.
> 
> Untested for now. If you are ok, then I will post with a better
> changelog.

Yeah, this looks very nice to me.

Thanks,

	Ingo
