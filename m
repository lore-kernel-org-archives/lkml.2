Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab1FWAHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:07:11 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:31626
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757685Ab1FWAHJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:07:09 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 23 Jun 2011 08:12:35 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <patches@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Jason Liu <jason.hui@linaro.org>, <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
Message-ID: <20110623001234.GB25799@S2100-06.ap.freescale.net>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-2-git-send-email-shawn.guo@linaro.org>
 <20110618161934.GH8195@ponder.secretlab.ca>
 <20110619073000.GA23171@S2100-06.ap.freescale.net>
 <20110621135558.GB9228@S2101-09.ap.freescale.net>
 <BANLkTim4vunTm1176MRw3pqRZnunu4=9jg@mail.gmail.com>
 <20110622153353.GA25799@S2100-06.ap.freescale.net>
 <BANLkTimsk2eWKPi2hnHbaAn-vSMKmdYsGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <BANLkTimsk2eWKPi2hnHbaAn-vSMKmdYsGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 09:52:11AM -0600, Grant Likely wrote:
[...]
> 
> >> > -       line = of_get_property(node, "id", NULL);
> >> > -       if (!line)
> >> > +       line = of_get_device_index(node, "serial");
> >> > +       if (IS_ERR_VALUE(line))
> >> >                return -ENODEV;
> >>
> >> Personally, it an alias isn't present, then I'd dynamically assign a port id.
> >>
> > We probably can not.  The driver works with being told the correct
> > port id which is defined by soc.  Instead of dynamically assigning
> > a port id, we have to tell the driver the exact hardware port id of
> > the device that is being probed.
> 
> Are you sure?  It doesn't look like the driver behaviour uses id for
> anything other than an index into the statically allocated serial port
> instance table.  I don't see any change of behaviour based on the port
> number anywhere.
> 
Sorry, I did not make this clear.  In serial_imx_probe(), the port
gets created and then saved as below.

	imx_ports[sport->port.line] = sport;

While in imx_console_setup(), it addresses the port as following.

	sport = imx_ports[co->index];

When users specify their console as ttymxc0, they mean they are
using the first i.mx uart hardware port, in turn ttymxc1 for the
second port ...

That said, imx_port[0] has to be the first hardware port, imx_port[1]
has to be the second one ...  That's why port id sport->port.line
can not be dynamically assigned, otherwise console may not work.

-- 
Regards,
Shawn

