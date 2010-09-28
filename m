Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab0I1PdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:33:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab0I1PdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:33:17 -0400
Date: Tue, 28 Sep 2010 11:32:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Robert Richter <robert.richter@amd.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
Message-ID: <20100928153247.GL26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
 <20100927100901.GC32222@erda.amd.com>
 <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
 <20100927133816.GP13563@erda.amd.com>
 <20100927152014.GY26290@redhat.com>
 <1285634172.20791.92.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285634172.20791.92.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 08:36:12AM +0800, Huang Ying wrote:
> > I tend to agree with Robert here.  I don't know if there were any 'rules'
> > to which handlers get directly called versus ones that go through the
> > die_chain, so I was originally going to let it go.  But if they aren't
> > any, it does look cleaner to have everything in die_chains.
> 
> Personally, I think directly call has better readability than

I am confused what type of readability you are looking for?  Can we create
a sysfs entry to give you that info?

> notifier_chain in general. Notifier_chain is for:
> 
> - Call functions in module.
> - Need to enable/disable (via register/unregister) at run time.
> - Call functions from low layer to high layer.
> 
> Otherwise, notifier_chain should be avoid if possible. So I think it is
> better to keep direct call as much as possible.

But the problem is you have to export all this platform specific stuff to
traps.c and surround the code with #ifdef's, which start to look ugly.

Is there any reason why traps.c should know about MCA/HEST/<other hardware
errors>?  Shouldn't it be abstracted away?

Honestly, I would be interested in creating a southbridge driver and
moving the port 0x61 code there and keeping the default_do_nmi() function
stupidly simple (just a call to the die_chain and the
unknown_nmi_error()).

Just my two cents.

Cheers,
Don
