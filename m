Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1JXIYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 04:24:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55943 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab1JXIYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 04:24:05 -0400
MIME-Version: 1.0
In-Reply-To: <20111024081244.GD15288@legolas.emea.dhcp.ti.com>
References: <20111024064227.GW5453@legolas.emea.dhcp.ti.com>
 <20111024074124.GB8708@ponder.secretlab.ca> <20111024074957.GB15288@legolas.emea.dhcp.ti.com>
 <CACxGe6v0kHNyO81XapR=jGEa8ZgJrUxN2EEiqW7c18NdurGNkg@mail.gmail.com> <20111024081244.GD15288@legolas.emea.dhcp.ti.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 24 Oct 2011 10:23:44 +0200
X-Google-Sender-Auth: uk2zb-Fi2PvTHwohixb_fDVcMIo
Message-ID: <CACxGe6uKremgkRA24PZk2DEAqiBudenoJA_x=DR=ByuDXoWncw@mail.gmail.com>
Subject: Re: DeviceTree and children devices
To: balbi@ti.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 10:12 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Oct 24, 2011 at 09:58:39AM +0200, Grant Likely wrote:
>> On Mon, Oct 24, 2011 at 9:49 AM, Felipe Balbi <balbi@ti.com> wrote:
>> > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
>> > index ed5a6d3..172d4a9 100644
>> > --- a/drivers/of/platform.c
>> > +++ b/drivers/of/platform.c
>> > @@ -204,7 +204,12 @@ struct platform_device *of_platform_device_create_pdata(
>> >  #if defined(CONFIG_MICROBLAZE)
>> >        dev->archdata.dma_mask = 0xffffffffUL;
>> >  #endif
>> > -       dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>> > +
>> > +       if (parent)
>> > +               dma_set_coherent_mask(&dev->dev, parent->coherent_dma_mask);
>> > +       else
>> > +               dma_set_coherent_mask(&dev->dev, DMA_BIT_MASK(32));
>> > +
>>
>> Right, this does need to be fixed.  The existing code just matched
>> what the historical powerpc code did, but it is certainly not correct.
>
> should I send patch above correctly ? Or do you want to also solve
> 32-bit coherent mask altogether ? What are your plans for that ? Add a
> separate property to pass coherent_mask size (32-bit, 64-bit, etc) ?

i don't know.  I'm not the expert on how the coherent mask should be
set.  Your patch does look sane as a starting point, but it bears
looking at by someone more cluefull than me.  In particular, someone
should investigate if the dma mask can be calculated from a dma-ranges
property.

g.
