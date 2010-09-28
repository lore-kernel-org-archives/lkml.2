Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316Ab0I1AgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:36:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:22260 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757865Ab0I1AgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:36:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,244,1283756400"; 
   d="scan'208";a="558518297"
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100927152014.GY26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
	 <20100927100901.GC32222@erda.amd.com>
	 <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
	 <20100927133816.GP13563@erda.amd.com>  <20100927152014.GY26290@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 08:36:12 +0800
Message-ID: <1285634172.20791.92.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 23:20 +0800, Don Zickus wrote:
> On Mon, Sep 27, 2010 at 03:38:16PM +0200, Robert Richter wrote:
> > On 27.09.10 08:47:53, huang ying wrote:
> > 
> > > I think explicit function calls have better readability than notifier chains.
> > 
> > What is different to unknown_nmi() then?
> > 
> > So no, in your case you want to catch unknown nmis for a certain
> > hardware and then throw a panic. This should be clearly implemented in
> > a separate handler for this piece of hardware.
> > 
> > We want to cleanup this code and throw out all hardware specific
> > snippets, and not introduce new special cases here.
> 
> I tend to agree with Robert here.  I don't know if there were any 'rules'
> to which handlers get directly called versus ones that go through the
> die_chain, so I was originally going to let it go.  But if they aren't
> any, it does look cleaner to have everything in die_chains.

Personally, I think directly call has better readability than
notifier_chain in general. Notifier_chain is for:

- Call functions in module.
- Need to enable/disable (via register/unregister) at run time.
- Call functions from low layer to high layer.

Otherwise, notifier_chain should be avoid if possible. So I think it is
better to keep direct call as much as possible.

Best Regards,
Huang Ying

