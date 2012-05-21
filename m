Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab2EULRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:17:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:1224 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2EULRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:17:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102356569"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xudong Hao <xudong.hao@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: RE: [PATCH 4/4] Enabling Access bit when doing memory swapping
Thread-Topic: [PATCH 4/4] Enabling Access bit when doing memory swapping
Thread-Index: AQHNMwB99DBQcMufFEKPOUTp11XjXpbOThaAgAVNAKD//9ERAIAAp38A//9+tICAAIwecA==
Date: Mon, 21 May 2012 11:17:32 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDC6F2E@SHSMSX102.ccr.corp.intel.com>
References: <20120516011230.GE14256@hp-xd.sh.intel.com>
 <20120518022241.GA14096@amt.cnet>
 <403610A45A2B5242BD291EDAE8B37D300FDC6BEE@SHSMSX102.ccr.corp.intel.com>
 <4FB9FD68.7000908@redhat.com>
 <403610A45A2B5242BD291EDAE8B37D300FDC6E99@SHSMSX102.ccr.corp.intel.com>
 <4FBA1D73.2030600@redhat.com>
In-Reply-To: <4FBA1D73.2030600@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Monday, May 21, 2012 6:48 PM
> To: Hao, Xudong
> Cc: Marcelo Tosatti; Xudong Hao; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; Shan, Haitao; Zhang, Xiantao
> Subject: Re: [PATCH 4/4] Enabling Access bit when doing memory swapping
> 
> On 05/21/2012 01:35 PM, Hao, Xudong wrote:
> > >
> > > That doesn't answer the question.  An atomic operation is now
> non-atomic.
> > >
> > > You can calculate shadow_accessed_bit and keep on using clear_bit(), or
> > > switch to cmpxchg64(), but don't just drop the dirty bit here.
> > >
> >
> > I know your meaning. How about this changes:
> >
> > ...
> >             young = 1;
> > +            if (enable_ept_ad_bits)
> > +                clear_bit(ffs(shadow_accessed_mask), (unsigned long
> *)spte);
> 
> ffs() returns an off-by-one result, so this needs to be adjusted. 

Yes, it need to decrease 1, I'll send v3 version for patch4, any other comments?

> IIRC
> bsfl is slow, but this shouldn't be a problem here.
> 

I do not know the story...

> 
> --
> error compiling committee.c: too many arguments to function

