Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab0IMCCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 22:02:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:39439 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376Ab0IMCCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 22:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,356,1280732400"; 
   d="scan'208";a="606302525"
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100913010248.GH21909@erda.amd.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	 <1284087065-32722-3-git-send-email-ying.huang@intel.com>
	 <20100913010248.GH21909@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 10:02:06 +0800
Message-ID: <1284343326.3269.70.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 09:02 +0800, Robert Richter wrote:
> On 09.09.10 22:51:02, Huang Ying wrote:
> > memory parity error is only valid for IBM PC-AT, newer machine use 7
> > bit (0x80) of 0x61 port for PCI SERR. While memory error is usually
> > reported via MCE. So corresponding function name and kernel log string
> > is changed.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  arch/x86/include/asm/mach_traps.h |    6 +++---
> >  arch/x86/kernel/traps.c           |   24 ++++++------------------
> >  2 files changed, 9 insertions(+), 21 deletions(-)
> > 
> > --- a/arch/x86/include/asm/mach_traps.h
> > +++ b/arch/x86/include/asm/mach_traps.h
> > @@ -9,11 +9,11 @@
> >  
> >  #define NMI_REASON_PORT		0x61
> >  
> > -#define NMI_REASON_MEMPAR	0x80
> > +#define NMI_REASON_SERR		0x80
> >  #define NMI_REASON_IOCHK	0x40
> > -#define NMI_REASON_MASK		(NMI_REASON_MEMPAR | NMI_REASON_IOCHK)
> > +#define NMI_REASON_MASK		(NMI_REASON_SERR | NMI_REASON_IOCHK)
> >  
> > -#define NMI_REASON_CLEAR_MEMPAR	0x04
> > +#define NMI_REASON_CLEAR_SERR	0x04
> >  #define NMI_REASON_CLEAR_IOCHK	0x08
> >  #define NMI_REASON_CLEAR_MASK	0x0f
> 
> Haven't you introduced *_MEMPAR with patch 1/6?

Yes. And I suggest to rename it to *_SERR in this patch to reflect the
contemporary hardware better. I think they are two steps: naming the
magic number and changing the name of constant and function.

Best Regards,
Huang Ying


