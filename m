Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab1LONi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 08:38:29 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:13939
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751022Ab1LONi1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:38:27 -0500
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Thu, 15 Dec 2011 21:51:30 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Jamie Iles <jamie@jamieiles.com>, Sascha Hauer <kernel@pengutronix.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
Message-ID: <20111215135129.GA2831@S2100-06.ap.freescale.net>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
 <20111212232903.GC2616@gallagher>
 <CACxGe6t50zJNpo=QWPzgFMpQ6Cfi9YZyrKuMSTrrA2oYiLF2Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CACxGe6t50zJNpo=QWPzgFMpQ6Cfi9YZyrKuMSTrrA2oYiLF2Pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 10:54:58AM -0700, Grant Likely wrote:
> On Mon, Dec 12, 2011 at 4:29 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> > Hi Grant,
> >
> > I'm still going through these and trying to digest them but a couple of
> > quick questions/comments.
> >
> > Jamie
> >
> > On Mon, Dec 12, 2011 at 03:02:04PM -0700, Grant Likely wrote:
> >> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >> new file mode 100644
> >> index 0000000..e40c436
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >> @@ -0,0 +1,114 @@
> >> +This binding is a work-in-progress, and are based on some experimental
> >> +work by benh[1].
> >> +
> >> +Sources of clock signal can be represented by any node in the device
> >> +tree.  Those nodes are designated as clock providers.  Clock consumer
> >> +nodes use a phandle and clock specifier pair to connect clock provider
> >> +outputs to clock inputs.  Similar to the gpio specifiers, a clock
> >> +specifier is an array of one more more cells identifying the clock
> >> +output on a device.  The length of a clock specifier is defined by the
> >> +value of a #clock-cells property in the clock provider node.
> >> +
> >> +[1] http://patchwork.ozlabs.org/patch/31551/
> >> +
> >> +==Clock providers==
> >> +
> >> +Required properties:
> >> +#clock-cells:           Number of cells in a clock specifier; typically will be
> >> +                set to 1
> >
> > I'm not sure I fully understand what the extra cells actually mean for
> > clocks.  I think the first integer is the clock output to use but some
> > of the versatile and highbank ones only have a phandle or is it more
> > implementation defined?  The clock-output-names description hints at
> > recommended, so I find this a little confusing, but that could just be
> > me!
> 
> I'm following convention here that has been established with
> interrupts, gpios, and others.  Sometimes more information is needed
> that just the clock number.  Using #clock-cells gives a clock provider
> the option of having additional fields for clock flags or other data.
> This is very much implementation defined.  Simple clock providers that
> only have a single clock output can easily use #clock-cells = <0>.
> Providers with multiple outputs will need to use 1 or more cells.
> 
It totally destroys my understanding on #clock-cells :)

I thought it's introduced to reduce the clock nodes in dts.  That said,
#clock-cells stands for the number of clks we describe in the node.
When #clock-cells > 1 for a node, the node becomes a clk blob which
actually contains multiple clks.  I migrated the imx6 clock to your
first post with this approach [1], using 70 nodes to describe 110
clocks (~35% nodes reduced).

Now, you are saying it's not designed for this purpose.  I'm pretty
confused, because the only reasonable use of #clock-cells to me is
just that way, and I fail to see why we need #clock-cells if we do
not use it that way.

http://comments.gmane.org/gmane.linux.drivers.devicetree/9631

-- 
Regards,
Shawn

