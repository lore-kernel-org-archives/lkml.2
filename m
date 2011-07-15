Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab1GONQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:16:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49002 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab1GONQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:16:11 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Dave Hylands <dhylands@gmail.com>, naveen yadav <yad.naveen@gmail.com>
CC: "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 15 Jul 2011 08:15:59 -0500
Subject: RE: ARM cortex A9 feature
Thread-Topic: ARM cortex A9 feature
Thread-Index: AcxCtPAcrb+zBv/GRhyE2NrAgF+AxAAON+Rg
Message-ID: <13B9B4C6EF24D648824FF11BE896716203F21C4D14@dlee02.ent.ti.com>
References: <CAJ8eaTzLmSTSMOY-0Xg0tE-DEbZ6RNA+uh70Dn3K5CbrjQsEiA@mail.gmail.com>
	<CABi1daHh7cgyhJ4c3zo+jSUY4uzbFtihtgw0Q2Mcrndno_gcTA@mail.gmail.com>
	<CAJ8eaTyqOBq2mbfvuTun=bVvhFSrMqJ5uVyd+cozF5PtVeSVaw@mail.gmail.com>
 <CABi1daFp=mKw0kq=Vm_T9RKeHfnXsA-kssdRm56AhkaJ4FjCxA@mail.gmail.com>
In-Reply-To: <CABi1daFp=mKw0kq=Vm_T9RKeHfnXsA-kssdRm56AhkaJ4FjCxA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-
> kernel-bounces@lists.infradead.org] On Behalf Of Dave Hylands
> Sent: Friday, July 15, 2011 1:03 AM
> To: naveen yadav

> > what is usecase for this . This is my question .
> 
> Since I've never used one, I'm not sure. Maybe somebody else knows.

The exclusive L2 feature is not the default option.

If you choose a small L2 size when configuring your CortexA hardware it might be useful.

A friend who did early x86/amd design indicated this feature was used when L1 & L2 caches were near the same size back in 90's. Going exclusive can have the effect of near doubling cache size.  As L2 got much bigger most folks stopped using it...presumably benchmarks fell off and it wasn't worth validation effort of carrying an option not commonly used.

The CortexA8 r1px rev's was exclusive only (like in omap3430).  Later A8 rev's (like omap3630) and A9 (omap4430) added and defaulted to non-exclusive.  Early L2's were 64K,128K,256K so adding 32K to a 64K probably did make sense.  Today in A9's (omap4460) and A15's (omap5430) with 1M and 2M L2 sizes +32K is not so impacting.

The A8's L2 was pretty quick (like 8 cycles) to registers on an A9 with external L2 you only can configure like 22 cycles.  Mixing with speed differences might create some other issues.

If you care about correlating benchmark results back to hardware actuals for things like lmbench, you find the exclusive configuration muddies several test results.

Regards,
Richard W.

