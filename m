Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0I3FVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 01:21:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:20906 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab0I3FVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 01:21:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,258,1283756400"; 
   d="scan'208";a="330366181"
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100930040432.GD26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
	 <20100927104426.GD32222@erda.amd.com>
	 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
	 <20100927134341.GQ13563@erda.amd.com> <20100927151607.GX26290@redhat.com>
	 <1285633705.20791.84.camel@yhuang-dev> <20100928151924.GJ26290@redhat.com>
	 <AANLkTinuNKfTBYTK1+Ks-QSPbQ3qz5cCZC6vUwUZ+zCh@mail.gmail.com>
	 <20100930040432.GD26290@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 13:21:14 +0800
Message-ID: <1285824074.6944.85.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-30 at 12:04 +0800, Don Zickus wrote:
> On Wed, Sep 29, 2010 at 02:55:58PM +0800, huang ying wrote:
> > Hi, Don,
> > 
> > I think we all agree that to use order to determine the reason/source
> > of NMI. The difference is that I want to keep as many direct calls in
> > default_do_nmi() as possible, while you guys want to wrap almost all
> > code in default_do_nmi() into notifier handler and leave only one
> > notify_die() in defualt_do_nmi(). And I want to use different die_val
> > (and their calling order in default_do_nmi()) to determine the order
> > while you guys want to use priority (based on its value) to determine
> > the order.
> 
> Well, I just wanted to see if we can minimize the number of times we
> walked the die_chain.  Priorities was an interesting idea, I am not sure
> it works out.  Registering two handlers, seems clunky.  But I am open to
> the discussions.

die_chain is used for multiple purposes now.

Although I don't like the idea. I think it may be possible to use just
one walking of die_chain to determine the source/reason of NMI.

But we need several walking of die_chain after determining the
source/reason and before the default processing. Such as DIE_NMIWATCHDOG
before go panic.

> > On the other hand, I think we should call corresponding DIE_NMIxxx
> > before the default operations, such as for watchdog, call
> > DIE_NMIWATCHDOG before go panic, for unknown nmi, call DIE_NMIUNKNOWN
> > before the default processing (may panic).
> > 
> > I think it is important to distinguish between die chain used to
> > determine the source/reason of NMI and the die chain used to see if
> > any other driver wanted to do some processing before the default
> > operation.
> 
> I guess I still prefer to take your patch set with its change and then
> layer any new ideas on top.  I have a feeling this discussion could go on
> forever regarding how die_chains can work.

Yes. I will send out a new version soon.

Best Regards,
Huang Ying


