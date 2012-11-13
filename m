Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2KMWC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 17:02:56 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:49136 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2KMWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:02:54 -0500
Date: Tue, 13 Nov 2012 16:02:57 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Mike Turquette <mturquette@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>, arm@kernel.org
Subject: Re: [PATCH v2 2/5] clk: Add support for fundamental zynq clks
Message-ID: <20121113220257.GN1718@beefymiracle.amer.corp.natinst.com>
References: <cover.1352400580.git.josh.cartwright@ni.com>
 <3569f4619a92904a40aecc9300aafe767ac736f7.1352400580.git.josh.cartwright@ni.com>
 <df95297d-a875-464a-b7a1-c494f2522a43@CO1EHSMHS027.ehs.local>
MIME-Version: 1.0
In-Reply-To: <df95297d-a875-464a-b7a1-c494f2522a43@CO1EHSMHS027.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/13/2012 04:02:48 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 11/13/2012 04:02:48 PM,
	Serialize complete at 11/13/2012 04:02:48 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8185,1.0.431,0.0.0000
 definitions=2012-11-13_08:2012-11-13,2012-11-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 03:28:07PM -0800, Soren Brinkmann wrote:
> One note below:
>
> On Wed, Oct 31, 2012 at 12:58:52PM -0600, Josh Cartwright wrote:
[..]
> > --- /dev/null
> > +++ b/drivers/clk/clk-zynq.c
[..]
> > +struct zynq_periph_clk {
> > +	struct clk_hw		hw;
> > +	struct clk_onecell_data	onecell_data;
> > +	struct clk		*gates[2];
> > +	void __iomem		*clk_ctrl;
> > +	spinlock_t		clkact_lock;
> > +};
> > +
> > +#define to_zynq_periph_clk(hw)	container_of(hw, struct zynq_periph_clk, hw)
> > +
> > +static const u8 periph_clk_parent_map[] = {
> > +	0, 0, 1, 2
> > +};
> > +#define PERIPH_CLK_CTRL_SRC(x)	(periph_clk_parent_map[((x) & 3) >> 4])
>
> I think this should be:
> #define PERIPH_CLK_CTRL_SRC(x)	(periph_clk_parent_map[((x) & 0x30) >> 4])

Yes indeed it should be, thanks.

Michal-  I'll just be following up with a v3 of this patch instead of
spinning up the whole set to save myself some time.  If you'd rather I
spin up the whole set, let me know.

Thanks,

  Josh
