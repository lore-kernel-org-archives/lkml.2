Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab1FWDfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:35:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62780 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab1FWDfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:35:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110623001234.GB25799@S2100-06.ap.freescale.net>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-2-git-send-email-shawn.guo@linaro.org> <20110618161934.GH8195@ponder.secretlab.ca>
 <20110619073000.GA23171@S2100-06.ap.freescale.net> <20110621135558.GB9228@S2101-09.ap.freescale.net>
 <BANLkTim4vunTm1176MRw3pqRZnunu4=9jg@mail.gmail.com> <20110622153353.GA25799@S2100-06.ap.freescale.net>
 <BANLkTimsk2eWKPi2hnHbaAn-vSMKmdYsGQ@mail.gmail.com> <20110623001234.GB25799@S2100-06.ap.freescale.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 22 Jun 2011 21:35:19 -0600
X-Google-Sender-Auth: bnUU2jwBYp7ASC3KeHUsCsejtEI
Message-ID: <BANLkTimgqmJDsAc+6aboszK33aBO2XiC6Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
To: Shawn Guo <shawn.guo@freescale.com>
Cc: patches@linaro.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Jason Liu <jason.hui@linaro.org>,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        David Gibson <david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 6:12 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Wed, Jun 22, 2011 at 09:52:11AM -0600, Grant Likely wrote:
> [...]
>>
>> >> > -       line = of_get_property(node, "id", NULL);
>> >> > -       if (!line)
>> >> > +       line = of_get_device_index(node, "serial");
>> >> > +       if (IS_ERR_VALUE(line))
>> >> >                return -ENODEV;
>> >>
>> >> Personally, it an alias isn't present, then I'd dynamically assign a port id.
>> >>
>> > We probably can not.  The driver works with being told the correct
>> > port id which is defined by soc.  Instead of dynamically assigning
>> > a port id, we have to tell the driver the exact hardware port id of
>> > the device that is being probed.
>>
>> Are you sure?  It doesn't look like the driver behaviour uses id for
>> anything other than an index into the statically allocated serial port
>> instance table.  I don't see any change of behaviour based on the port
>> number anywhere.
>>
> Sorry, I did not make this clear.  In serial_imx_probe(), the port
> gets created and then saved as below.
>
>        imx_ports[sport->port.line] = sport;
>
> While in imx_console_setup(), it addresses the port as following.
>
>        sport = imx_ports[co->index];
>
> When users specify their console as ttymxc0, they mean they are
> using the first i.mx uart hardware port, in turn ttymxc1 for the
> second port ...
>
> That said, imx_port[0] has to be the first hardware port, imx_port[1]
> has to be the second one ...  That's why port id sport->port.line
> can not be dynamically assigned, otherwise console may not work.

My point still stands.  If there is no number specifically assigned to
a device, then numbering should be dynamic.  That's standard behaviour
for Linux device drivers, and I get nervous every time I see a driver
that make an assumption to the contrary, especially when there is no
good reason for it.  Besides, you still can ensure the console is
reliable by having an alias for the console device.

g.
