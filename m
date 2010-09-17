Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0IQIha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:37:30 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57451 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab0IQIh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jwc2TnrV0J7+qXcGk3KgmNztvQwHwCZfEw4iIFw6KC8xvdlnvFc6uQkBv1pNlL7TUe
         oJIvthlgu67odZKZwrPZFiQ3yh3Cu+nCBM0sT/6B+7fCX4awY29UWgztw8v2JPqPXS0C
         OLHL+7sJ5QX02BFagi5EGIzQxlLsoV1Rx5Ny0=
Date: Fri, 17 Sep 2010 12:37:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
Message-ID: <20100917083723.GA6503@lenovo>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com> <1284118900.402.35.camel@laptop> <20100910132741.GB4879@redhat.com> <20100910144634.GA1060@elte.hu> <20100910155659.GD13563@erda.amd.com> <1284658950.2275.591.camel@laptop> <1284682396.32373.16.camel@yhuang-dev> <1284709936.3764.2241.camel@twins> <20100917081358.GJ13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917081358.GJ13563@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 10:13:58AM +0200, Robert Richter wrote:
> On 17.09.10 03:52:16, Peter Zijlstra wrote:
> > On Fri, 2010-09-17 at 08:13 +0800, Huang Ying wrote:
> > 
> > > Please take a look at my recent patch that rewrites the NMI handler.
> > 
> > (Link would have been useful)
> > 
> > > Where NMI are divided into two types. CPU specific NMI are processed
> > > firstly as DIE_NMI_IPI, and non-CPU specific NMI are processed as
> > > DIE_NMI.
> > 
> > OK, and you can discriminate between these two by means of that reason
> > port? Still I think NMI_IPI is a terrible name for that.
> 
> I think the current implementation that devides into NMI and NMI_IPI
> is just to keep a certain order when calling the handlers - handling
> local NMIs before non-CPU NMIs.
> 
...

This DIE_NMI_IPI definitely strange. Perhaps we could rename it to something
more understandable and implement separate notifier chain for it so that
code would not need to check if (... != DIE_NMI_IPI). Hm?

	-- Cyrill
