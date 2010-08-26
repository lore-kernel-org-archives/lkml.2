Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0HZJCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:02:08 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:57396 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0HZJCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:02:06 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqzbb2cK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7R507-01-AYS-02
X-M-MSG: 
Date: Thu, 26 Aug 2010 11:00:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100826090008.GA22783@erda.amd.com>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com>
 <20100820152510.GA4167@elte.hu>
 <20100825094819.GB3198@erda.amd.com>
 <20100825104130.GA27891@elte.hu>
 <20100825110006.GB27891@elte.hu>
 <20100825201106.GH4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100825201106.GH4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.08.10 16:11:06, Don Zickus wrote:
> >  cpu #15, nmi #160, marked #0, handled = 1, time = 333392635730, delta = 11238255
> >  cpu #15, nmi #161, marked #0, handled = 1, time = 333403779380, delta = 11143650
> >  cpu #15, nmi #162, marked #0, handled = 1, time = 333415418497, delta = 11639117
> >  cpu #15, nmi #163, marked #0, handled = 1, time = 333415467084, delta = 48587
> >  cpu #15, nmi #164, marked #0, handled = 1, time = 333415501531, delta = 34447
> >  cpu #15, nmi #165, marked #0, handled = 1, time = 333459918106, delta = 44416575
> >  cpu #15, nmi #166, marked #0, handled = 0, time = 333459923167, delta = 1666
> >  cpu #15, nmi #151, marked #0, handled = 1, time = 332978597882, delta = 11447002
> >  cpu #15, nmi #152, marked #0, handled = 1, time = 332978657151, delta = 59269
> >  cpu #15, nmi #153, marked #0, handled = 1, time = 332978667847, delta = 10696
> >  cpu #15, nmi #154, marked #0, handled = 1, time = 333023125757, delta = 44457910
> >  cpu #15, nmi #155, marked #0, handled = 1, time = 333291980833, delta = 268855076
> >  cpu #15, nmi #156, marked #0, handled = 1, time = 333325663125, delta = 33682292
> >  cpu #15, nmi #157, marked #0, handled = 1, time = 333348216481, delta = 22553356
> >  cpu #15, nmi #158, marked #0, handled = 1, time = 333370168887, delta = 21952406
> >  cpu #15, nmi #159, marked #0, handled = 1, time = 333381397475, delta = 11228588
> >  Uhhuh. NMI received for unknown reason 00 on CPU 15.
> >  Do you have a strange power saving mode enabled?
> >  Dazed and confused, but trying to continue
> 
> So I found a Nehalem box that can reliably reproduce Ingo's problem using
> something as simple 'perf top'.  But like above, I am noticing the
> samething, an extra NMI(PMI??) that comes out of nowhere.

This could also be a race in the counter handling code, or we do not
proper count the number of handled counters. Maybe 2 counters actually
fired but we only noticed one counter and then accidentially cleared
the 2nd without processing it.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

