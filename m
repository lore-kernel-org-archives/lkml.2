Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0IOWX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:23:29 -0400
Received: from smtp.nokia.com ([147.243.1.47]:35657 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab0IOWX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:23:27 -0400
Date: Thu, 16 Sep 2010 01:22:16 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Tony Luck <tony.luck@intel.com>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] ia64: possible module unwind table optimisation
Message-ID: <20100915222216.GF27658@esdhcp04044.research.nokia.com>
References: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com> <AANLkTi=RsA0tACWOg+8RTSuDHwa4LGOiyO-4TxpJ_rb5@mail.gmail.com> <20100915124831.GB27658@esdhcp04044.research.nokia.com> <AANLkTi=hPcXC1=Lrey1H_UHRJRJ-NdTsvmyxgP_n+dM8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=hPcXC1=Lrey1H_UHRJRJ-NdTsvmyxgP_n+dM8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/09/10 19:28 +0200, ext Tony Luck wrote:
> On Wed, Sep 15, 2010 at 5:48 AM, Phil Carmody
> <ext-phil.2.carmody@nokia.com> wrote:
> >>   for (table = unw.tables; table; table = table->next)
> >>
> >> before we find the right table to look?
> >
> > Yes, that's the one. Sorry I wasn't more explicit.
> 
> My usual workload (building new Linux kernels - what else :-) doesn't
> seem to generate
> any unwind requests.  I reached the loop just 58 times while booting,
> and only did 23
> steps past the first item [didn't track a histogram, so I don't know
> whether that was a
> single 23 step lookup, or 23 one-step ones].  Building the kernel
> (make -j32) didn't add
> to either count.
> 
> Workload ideas?

Turn on kmemleak, or anything else which repeatedly runs up the stack just
for the fun of gathering backtraces. Kmemleak's what caused us to notice 
the issue in our ARM-based environment.

Phil
