Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0IQANU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 20:13:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:12138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab0IQANT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 20:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,378,1280732400"; 
   d="scan'208";a="658194702"
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
In-Reply-To: <1284658950.2275.591.camel@laptop>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	 <1284118900.402.35.camel@laptop> <20100910132741.GB4879@redhat.com>
	 <20100910144634.GA1060@elte.hu>  <20100910155659.GD13563@erda.amd.com>
	 <1284658950.2275.591.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 08:13:16 +0800
Message-ID: <1284682396.32373.16.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 01:42 +0800, Peter Zijlstra wrote:
> On Fri, 2010-09-10 at 17:56 +0200, Robert Richter wrote:
> > The commit:
> > 
> >  e40b172 x86: Move notify_die from nmi.c to traps.c
> > 
> > moved the nmi handler call to default_do_nmi(). DIE_NMI_IPI and
> > DIE_NMI are called subsequently now. If the return code is
> > !NOTIFY_STOP, then the handlers are called twice. This patch fixes
> > this. 
> 
> What is this NMI_IPI thing, and why do we bother?
> 
> If the hardware reason thin can discriminate between IPI and other NMIs
> we should never call both chains, if it cannot, why do we have 2 chains?
> 
> In any case, I don't think perf/oprofile/etc,. should use NMI_IPI, that
> doesn't really make sense.
> 
> Or am I totally confused about things here?

Please take a look at my recent patch that rewrites the NMI handler.
Where NMI are divided into two types. CPU specific NMI are processed
firstly as DIE_NMI_IPI, and non-CPU specific NMI are processed as
DIE_NMI.

CPU specific NMIs include perf event, oprofile, crash, etc. They can be
processed on specific CPU only.

non-CPU specific NMIs include SERR and IOCHK NMI (via checking port
0x61) and APEI GHES NMI. They can be processed on any CPU.

Best Regards,
Huang Ying


