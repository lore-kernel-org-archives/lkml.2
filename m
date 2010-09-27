Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab0I0PU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:20:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab0I0PU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:20:26 -0400
Date: Mon, 27 Sep 2010 11:20:14 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
Message-ID: <20100927152014.GY26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
 <20100927100901.GC32222@erda.amd.com>
 <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
 <20100927133816.GP13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927133816.GP13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 03:38:16PM +0200, Robert Richter wrote:
> On 27.09.10 08:47:53, huang ying wrote:
> 
> > I think explicit function calls have better readability than notifier chains.
> 
> What is different to unknown_nmi() then?
> 
> So no, in your case you want to catch unknown nmis for a certain
> hardware and then throw a panic. This should be clearly implemented in
> a separate handler for this piece of hardware.
> 
> We want to cleanup this code and throw out all hardware specific
> snippets, and not introduce new special cases here.

I tend to agree with Robert here.  I don't know if there were any 'rules'
to which handlers get directly called versus ones that go through the
die_chain, so I was originally going to let it go.  But if they aren't
any, it does look cleaner to have everything in die_chains.

Cheers,
Don
