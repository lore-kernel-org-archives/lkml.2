Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab1HDRNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 13:13:19 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:13628
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab1HDRNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 13:13:14 -0400
X-SpamScore: -14
X-BigFish: VS-14(z78cMz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 5 Aug 2011 01:13:02 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Felipe Balbi <balbi@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] dt: remove of_alias_get_id() reference
Message-ID: <20110804170932.GA10897@freescale.com>
References: <20110804102950.10845.67898.stgit@ponder>
 <20110804103336.GE17540@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110804103336.GE17540@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 01:33:37PM +0300, Felipe Balbi wrote:
> On Thu, Aug 04, 2011 at 11:30:27AM +0100, Grant Likely wrote:
> > of_alias_get_id() is broken and being reverted.  Remove the reference
> > to it and replace with a single incrementing id number.
> > 
> > There is no risk of regression here on the imx driver since the imx
> > change to use of_alias_get_id() is commit 22698aa2, "serial/imx: add
> > device tree probe support" which is new for v3.1, and it won't get
> > used unless CONFIG_OF is enabled and the board is booted using a
> > device tree.  A single incrementing integer is sufficient for now.
> > 
> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> > Acked-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> > 
> > I'm about to ask Linus to pull this patch through the devicetree/merge
> > branch along with the of_alias revert.
> > 
> >  drivers/tty/serial/imx.c |   13 ++++---------
> >  1 files changed, 4 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> > index 827db76..7e91b3d 100644
> > --- a/drivers/tty/serial/imx.c
> > +++ b/drivers/tty/serial/imx.c
> > @@ -1286,22 +1286,17 @@ static int serial_imx_resume(struct platform_device *dev)
> >  static int serial_imx_probe_dt(struct imx_port *sport,
> >  		struct platform_device *pdev)
> >  {
> > +	static int portnum = 0;
> 
> would it be better to use an IDR here ?
> 

This patch is a step back to avoid using of_alias_* api since it's
been reverted.  But we need to fix the api to make it right later.
That said the serial will still go after the of_alias_get_id.

What we want is a fixed device id for specified serial instance,
which is defined by device tree (in turn by hardware), instead of
a random id.  I'm not sure that I completely understand what IDR is
exactly for.  But from the documentation in lib/idr.c, I feel it's
not what we need here.  Or can you please elaborate why it fits here?

/*
 * You call it to allocate an id (an int) an associate with that id a
 * pointer or what ever, we treat it as a (void *).  You can pass this
 * id to a user for him to pass back at a later time.  You then pass
 * that id to this code and it returns your pointer.
 */

-- 
Regards,
Shawn

