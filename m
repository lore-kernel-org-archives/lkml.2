Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab2EQGaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 02:30:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:55878 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801Ab2EQGau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 02:30:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101071113"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Avi Kivity <avi@redhat.com>, Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Xudong Hao <xudong.hao@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Subject: RE: [PATCH 0/4] KVM: Enable EPT access bit feature
Thread-Topic: [PATCH 0/4] KVM: Enable EPT access bit feature
Thread-Index: AQHNMv9jrj/rlszff0qa5bgUZOdn1ZbLno6AgABGz4CAAAJOAIABZgMA
Date: Thu, 17 May 2012 06:30:45 +0000
Message-ID: <403610A45A2B5242BD291EDAE8B37D300FDC5CD5@SHSMSX102.ccr.corp.intel.com>
References: <20120516010439.GA14256@hp-xd.sh.intel.com>
 <4FB371B1.7000407@redhat.com>
 <20120516223519.4f7d6fdc864a552ce67161e9@gmail.com>
 <4FB3AF06.4070307@redhat.com>
In-Reply-To: <4FB3AF06.4070307@redhat.com>
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
> Sent: Wednesday, May 16, 2012 9:44 PM
> To: Takuya Yoshikawa
> Cc: Xudong Hao; kvm@vger.kernel.org; linux-kernel@vger.kernel.org; Shan,
> Haitao; Zhang, Xiantao; Hao, Xudong
> Subject: Re: [PATCH 0/4] KVM: Enable EPT access bit feature
> 
> On 05/16/2012 04:35 PM, Takuya Yoshikawa wrote:
> > On Wed, 16 May 2012 12:21:53 +0300
> > Avi Kivity <avi@redhat.com> wrote:
> >
> > > On 05/16/2012 04:04 AM, Xudong Hao wrote:
> > > > EPT A/D bits enable VMMs to efficiently implement memory management
> and page classification algorithms to optimize VM memory operations such as
> de-fragmentation, paging, live-migration, and check-pointing.
> > > >
> > > > The series of patches enable the EPT access bit in KVM.
> > > >
> > > > PATCH 1: Add EPT A/D bits definition.
> > > > PATCH 2: Add kernel parameter to control EPT A/D bits support, the
> feature is on by default.
> > > > PATCH 3: Enable EPT A/D bits if supported by turning on relevant bit in
> EPTP.
> > > > PATCH 4: Enabling Access bit when doing memory swapping.
> > > >
> > >
> > > Minor comment on patch 2, but otherwise looks good.
> >
> > Except for being white space damaged and based on old kvm.git?
> 
> Ugh, I didn't notice that.  Xudong, please rebase on kvm.git 'next', and
> repost using git send-email.
> 

Oh, my patch is based on 'master' branch, I saw some changes in mmu.c by Takuya which will conflict patch 4, I'll rebase on 'next' branch.
Anyway, I'll send whole four patches as v2 of 'next' branch.

> > BTW, we can use this for dirty logging as you suggested.
> >
> > Although we need to traverse each spte from rmap
> 
> That should be cheap.  Also, we might be able to cheat for direct-mapped
> pages: if all pages in a 2M area are mapped just once, in a
> direct-mapped page, we can skip rmap and iterate over the page
> directly.  We can store this hint in lpage_info.
> 
> There's a chance that this optimization will gain nothing since the
> processor may be able to unroll the loop and hide the rmap costs for the
> next spte behind the atomic access cost for the current spte.
> 
> > and sync with dirty
> > bitmap, I think it will work well by using with range based GET_DIRTY_LOG
> > to restrict the cost for one call.
> 
> I'm in favour of that as well (even more, since the install base will be
> dominated by non-AD-capable hosts for some time).
> 
> --
> error compiling committee.c: too many arguments to function

