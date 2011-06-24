Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1FXEFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 00:05:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56508 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1FXEFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 00:05:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110624034859.GB19188@S2100-06.ap.freescale.net>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-2-git-send-email-shawn.guo@linaro.org> <20110618161934.GH8195@ponder.secretlab.ca>
 <20110619073000.GA23171@S2100-06.ap.freescale.net> <20110621135558.GB9228@S2101-09.ap.freescale.net>
 <BANLkTim4vunTm1176MRw3pqRZnunu4=9jg@mail.gmail.com> <20110623183821.GA19188@S2100-06.ap.freescale.net>
 <BANLkTi=8Mks6T85WnEyihmB21U1j7reHrQ@mail.gmail.com> <20110624034859.GB19188@S2100-06.ap.freescale.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 23 Jun 2011 22:05:00 -0600
X-Google-Sender-Auth: VzM-b-mh53OAvBFOIfjU44nJ4eE
Message-ID: <BANLkTimXZvW16uMRGMeyH203e6MHxdNbSA@mail.gmail.com>
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

On Thu, Jun 23, 2011 at 9:49 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Thu, Jun 23, 2011 at 05:11:54PM -0600, Grant Likely wrote:
>> > +               int devid = get_alias_name_id(pp->name, devname);
>> > +
>> > +               /* We do not want to proceed this sentinel one */
>> > +               if (!strcmp(pp->name, "name") && !strcmp(pp->value, "aliases"))
>> > +                       break;
>>
>> Skipping the 'name' property is good, but I don't think you need to
>> check the value.  You should also skip the "phandle" property.
>>
> Ok. I have not seen "phandle" property in aliases node though.  Can
> you give me an example, so that I can make one up for testing?

It's a standard property that shows up automatically if any node
happens to have a phandle reference to another node.  The name will be
either "phandle" or "linux,phandle".  Search for "linux,phandle" in
drivers/of/fdt.c to see how that property is processed.

g.
