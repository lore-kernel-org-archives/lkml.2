Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab2F2KeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:34:13 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:33821
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077Ab2F2KeJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:34:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VS-8(zz98dI9371I936eI542M1432Izz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ahbe9i)
From: Zhao Chenhui-B35336 <B35336@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: Wood Scott-B07421 <B07421@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Topic: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
Thread-Index: AQHNU+iOH9ZR6POnykuMZsr+pwF9IZcOSUYAgAAYXwCAAQlBgIAAeN6AgACAaACAALProA==
Date: Fri, 29 Jun 2012 10:33:45 +0000
Message-ID: <7AA2FF042C086D469F577FA6723434DA05D87E@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1340706359-9455-1-git-send-email-chenhui.zhao@freescale.com>
 <1340748634.3732.27.camel@pasglop>
 <20120627102138.GB10476@localhost.localdomain>
 <1340797732.3732.46.camel@pasglop>
 <20120628033815.GA11387@localhost.localdomain>
 <1340880651.20977.83.camel@pasglop>
 <D2BA086B-6EB3-4853-B901-FA37DCCDC134@kernel.crashing.org>
In-Reply-To: <D2BA086B-6EB3-4853-B901-FA37DCCDC134@kernel.crashing.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.51]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Linuxppc-dev [mailto:linuxppc-dev-bounces+chenhui.zhao=freescale.com@lists.ozlabs.org] On Behalf
> Of Kumar Gala
> Sent: Friday, June 29, 2012 2:30 AM
> To: Zhao Chenhui-B35336
> Cc: Wood Scott-B07421; linuxppc-dev@lists.ozlabs.org list; linux-kernel@vger.kernel.org list
> Subject: Re: [PATCH v6 1/5] powerpc/85xx: implement hardware timebase sync
> 
> 
> On Jun 28, 2012, at 5:50 AM, Benjamin Herrenschmidt wrote:
> 
> > On Thu, 2012-06-28 at 11:38 +0800, Zhao Chenhui wrote:
> >>
> >>
> >> The bootloader have done a timebase sync. If we do not need KEXEC or
> >> HOTPLUG_CPU feature, it is unnecessary to do it again at boot time of
> >> kernel. I only compile the timebase sync routines
> >> when users enable KEXEC or HOTPLUG_CPU.
> >
> > Still, how much are you really saving ? Is it worth the added mess and
> > loss of test coverage ?
> >
> > We have too many conditional stuff like that already.
> >
> > Cheers,
> > Ben.
> >
> 
> I'd also be interested to know how long it actually takes to do time base sync this way.  Since you
> are freezing the timers for some period how long does it really take between the freeze/unfreeze in
> mpc85xx_give_timebase()
> 
> +	mpc85xx_timebase_freeze(1);
> ...
> +	mpc85xx_timebase_freeze(0);
> 
> You can use ATBL/U as a way to see # of cycles taken.
> 
> - k

I measured it using ATBL on MPC8572DS with 1.5GHz core frequency and 600MHz CCB frequency.
The average of 10 times is 1019 clock. It seems that most of the time spent by isync and msync.

-Chenhui

