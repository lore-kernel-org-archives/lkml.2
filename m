Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab0I3EEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:04:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab0I3EEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:04:47 -0400
Date: Thu, 30 Sep 2010 00:04:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100930040432.GD26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
 <20100927104426.GD32222@erda.amd.com>
 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
 <20100927134341.GQ13563@erda.amd.com>
 <20100927151607.GX26290@redhat.com>
 <1285633705.20791.84.camel@yhuang-dev>
 <20100928151924.GJ26290@redhat.com>
 <AANLkTinuNKfTBYTK1+Ks-QSPbQ3qz5cCZC6vUwUZ+zCh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinuNKfTBYTK1+Ks-QSPbQ3qz5cCZC6vUwUZ+zCh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 02:55:58PM +0800, huang ying wrote:
> Hi, Don,
> 
> I think we all agree that to use order to determine the reason/source
> of NMI. The difference is that I want to keep as many direct calls in
> default_do_nmi() as possible, while you guys want to wrap almost all
> code in default_do_nmi() into notifier handler and leave only one
> notify_die() in defualt_do_nmi(). And I want to use different die_val
> (and their calling order in default_do_nmi()) to determine the order
> while you guys want to use priority (based on its value) to determine
> the order.

Well, I just wanted to see if we can minimize the number of times we
walked the die_chain.  Priorities was an interesting idea, I am not sure
it works out.  Registering two handlers, seems clunky.  But I am open to
the discussions.

> 
> On the other hand, I think we should call corresponding DIE_NMIxxx
> before the default operations, such as for watchdog, call
> DIE_NMIWATCHDOG before go panic, for unknown nmi, call DIE_NMIUNKNOWN
> before the default processing (may panic).
> 
> I think it is important to distinguish between die chain used to
> determine the source/reason of NMI and the die chain used to see if
> any other driver wanted to do some processing before the default
> operation.

I guess I still prefer to take your patch set with its change and then
layer any new ideas on top.  I have a feeling this discussion could go on
forever regarding how die_chains can work.

Cheers,
Don
