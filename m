Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab2KNPNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 10:13:06 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:23602
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932713Ab2KNPNE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 10:13:04 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(zz98dI9371I542M1432Izz1de0h1202h1d1ah1d2ahzz8275dhz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        Soren Brinkmann <sorenb@xilinx.com>
CC: Mike Turquette <mturquette@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, "arm@kernel.org" <arm@kernel.org>
Subject: RE: [PATCH v2 2/5] clk: Add support for fundamental zynq clks
Thread-Topic: [PATCH v2 2/5] clk: Add support for fundamental zynq clks
Thread-Index: AQHNvesHa2yWADlh/k+CmLiXL7D9I5foWYvKgAEfl+A=
Date: Wed, 14 Nov 2012 15:12:54 +0000
References: <cover.1352400580.git.josh.cartwright@ni.com>
 <3569f4619a92904a40aecc9300aafe767ac736f7.1352400580.git.josh.cartwright@ni.com>
 <df95297d-a875-464a-b7a1-c494f2522a43@CO1EHSMHS027.ehs.local>
 <20121113220257.GN1718@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121113220257.GN1718@beefymiracle.amer.corp.natinst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.24.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <4d134063-467e-4ae9-9070-e45d5dc11c36@CH1EHSMHS010.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Tuesday, November 13, 2012 11:03 PM
> To: Soren Brinkmann; Michal Simek
> Cc: Mike Turquette; Rob Herring; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; John Linn; arm@kernel.org
> Subject: Re: [PATCH v2 2/5] clk: Add support for fundamental zynq clks
>
> On Thu, Nov 08, 2012 at 03:28:07PM -0800, Soren Brinkmann wrote:
> > One note below:
> >
> > On Wed, Oct 31, 2012 at 12:58:52PM -0600, Josh Cartwright wrote:
> [..]
> > > --- /dev/null
> > > +++ b/drivers/clk/clk-zynq.c
> [..]
> > > +struct zynq_periph_clk {
> > > + struct clk_hw           hw;
> > > + struct clk_onecell_data onecell_data;
> > > + struct clk              *gates[2];
> > > + void __iomem            *clk_ctrl;
> > > + spinlock_t              clkact_lock;
> > > +};
> > > +
> > > +#define to_zynq_periph_clk(hw)   container_of(hw, struct zynq_periph_clk,
> hw)
> > > +
> > > +static const u8 periph_clk_parent_map[] = {
> > > + 0, 0, 1, 2
> > > +};
> > > +#define PERIPH_CLK_CTRL_SRC(x)   (periph_clk_parent_map[((x) & 3) >> 4])
> >
> > I think this should be:
> > #define PERIPH_CLK_CTRL_SRC(x)      (periph_clk_parent_map[((x) & 0x30) >>
> 4])
>
> Yes indeed it should be, thanks.
>
> Michal-  I'll just be following up with a v3 of this patch instead of spinning up the
> whole set to save myself some time.  If you'd rather I spin up the whole set, let
> me know.


No problem with that.

thanks,
Michal


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


