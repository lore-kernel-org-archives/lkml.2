Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab2J0Qwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 12:52:47 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:59490
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab2J0Qwp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 12:52:45 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 7
X-BigFish: VPS7(zz98dI9371I936eI542M1432I4015Izz1202h1d1ah1d2ahzzz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        Nick Bowler <nbowler@elliptictech.com>
CC: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>
Subject: RE: [PATCH v4 5/5] zynq: move static peripheral mappings
Thread-Topic: [PATCH v4 5/5] zynq: move static peripheral mappings
Thread-Index: AQHNsiLZXEqEbirtRkGkwIsBB3utp5fKZliAgAAUHwCAABQlAIAAJ6eAgAKrUFA=
Date: Sat, 27 Oct 2012 16:52:38 +0000
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200451.GF6713@beefymiracle.amer.corp.natinst.com>
 <20121025201701.GA18217@elliptictech.com>
 <20121025212902.GX20593@beefymiracle.amer.corp.natinst.com>
 <20121025224108.GA30705@elliptictech.com>
 <20121026010303.GA13669@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121026010303.GA13669@beefymiracle.amer.corp.natinst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.65]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <09a36c6c-af3b-42d2-a58a-a13ee64d9a02@CO1EHSMHS017.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Josh and Nick,

look below.

> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Friday, October 26, 2012 3:03 AM
> To: Nick Bowler
> Cc: arm@kernel.org; Arnd Bergmann; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; John Linn; Michal Simek
> Subject: Re: [PATCH v4 5/5] zynq: move static peripheral mappings
> 
> On Thu, Oct 25, 2012 at 06:41:08PM -0400, Nick Bowler wrote:
> > On 2012-10-25 16:29 -0500, Josh Cartwright wrote:
> > > On Thu, Oct 25, 2012 at 04:17:01PM -0400, Nick Bowler wrote:
> > > > Did you test this on any real hardware?  I can't get the ZC702 to
> > > > work with the UART mapped at this address (this ends up being
> > > > mapped at 0xFEFFF000), although I can't for the life of me figure
> > > > out why the virtual address even matters.  Note that for the
> > > > ZC702, the physical address of the "main" UART is 0xE0001000.
> 
> Good news is you're not crazy; I was able to duplicate the problem here.
> 
> > If I were to guess, I would guess that, except for when it "Works",
> > the really really early printk stuff isn't actually hitting the uart
> > at all.  The "Fails" case would then be due to the stray writes
> > crashing the board, and the "Truncated" case due to the stray writes
> > being (ostensibly) benign.
> 
> If I'm not mistaken, this hypothesis is predicated on the early bootup code
> establishing a (linear?) mapping for addresses > VMALLOC_START; before the
> mdesc->map_io() is even handled.  That seems odd to me.
> 
> > But I really have no way right now to test this hypothesis, since I
> > can't print anything in the failing case.
> 
> Not sure if I'll be able to get anything meaningful out of it yet (I've not
> historically had good luck with Xilinx's debugging tools), but I did finally get a
> JTAG debugger hooked up to the zc702.  I'll see if I can get any useful
> information tomorrow.

I have seen the same problem on zc702. I will debug it.
Josh: the best will be if you can send v5 for patches 1-3 (1 with small changes in dts - uart)  which I will apply
to arm-next. 

4/5 should go out of zynq subtree, it means directly to arm-soc or via Russel's tree. 

5/5 + Nick patch should be tested. 

Thanks,
Michal


