Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab0JTBNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:13:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:7424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab0JTBNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="668991294"
Subject: Re: [patch]x86: spread tlb flush vector between nodes
From: Shaohua Li <shaohua.li@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20101019133426.GB11654@basil.fritz.box>
References: <1286955698.13317.5.camel@sli10-conroe.sh.intel.com>
	 <20101013081629.GA1621@basil.fritz.box>
	 <1286959176.24888.6.camel@sli10-conroe.sh.intel.com>
	 <1287466757.29515.2.camel@sli10-conroe.sh.intel.com>
	 <6dd05e19-05ef-48e4-b42d-d18c913fa4d7@email.android.com>
	 <20101019084423.GB27723@elte.hu>
	 <1287478532.9456.0.camel@sli10-conroe.sh.intel.com>
	 <20101019103759.GC32212@elte.hu> <1287494931.1699.12.camel@shli-laptop>
	 <20101019133426.GB11654@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 09:13:41 +0800
Message-ID: <1287537221.15980.3.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 21:34 +0800, Andi Kleen wrote:
> >  
> > +static int tlb_vector_offset[NR_CPUS] __read_mostly;
> 
> Never use NR_CPUS. Always use per cpu data.
> 
> Otherwise you waste a lot of space on a CONFIG_MAX_SMP
> kernel running on a smaller box.
ha, I want it to be __read_mostly to avoid cache pollution, apparently
we have no per cpu API to do this. Maybe I need add one.

Thanks,
Shaohua

