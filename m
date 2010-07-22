Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0GVVye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:54:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38946 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0GVVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MOQaARhS/UhHcJMYfx5lEMV104TfhOqbBbJRP3EyhAG4AQjm21xONAbjm/uXbZWtNT
         uXf2tRw5R2N9uBj5SM97JgKopvmaxR/t5WT1cpuasfs0LdK8/XRihDFLIlheDwCOwbfs
         mXri8tUDB+8r8jU9Ig4aZOheMysKAoV21OTFs=
MIME-Version: 1.0
In-Reply-To: <438BB0150E931F4B9CE701519A44630104A3914683@bgsmsx502.gar.corp.intel.com>
References: <1279740148-22186-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTimmJJcMXxICZHjksp_TjqO_JRx9HwCTJ6UpZQOZ@mail.gmail.com>
	<438BB0150E931F4B9CE701519A44630104A3914683@bgsmsx502.gar.corp.intel.com>
Date: Thu, 22 Jul 2010 23:54:31 +0200
Message-ID: <AANLkTinIiBSADC0JIKSd2J55d5Lj0epc9o4WKXF8rsek@mail.gmail.com>
Subject: Re: [PATCH 1/3] DMAENGINE: generic slave channel control v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/22 Koul, Vinod <vinod.koul@intel.com>:

> Shouldn't this patch remove the private member in dma_chan structure

I don't think so.

> Currently chan->private is used for sending slave or similar channel specific
> information. Now if we want to add struct dma_slave_config, then IMHO it
> would make sense to remove private variable and replace with dma_slave_config
> struture. That way we can reuse this struture there as well and if someone wants
> to add more stuff he can use the private_config.

That member is described like this:
@private: private data for certain client-channel associations

chan->private is supposed to only be used inside the dmaengine
drivers themselves AFAICT.

Some drivers (like the txx9dmac.c) use this to hold the state of the
slave, whereas the void *private in the runtime config is supposed
to contain some custom configuration struct which is created
outside of the dmaengine framework and can be discarded
after use (if you so wish), so that's vastly different.

You could however argue (but this is another discussion altogether)
that using chan->private to hold any states is superfluous since
you could just have  your struct dma_channel as a member of
your custom channel struct and use container_of to dereference
it (as we do in the coh901318 and ste_dma40 drivers) and then
stockpile any other struct members or substructs into your custom
struct but that's another issue, which would require major refactoring
of these drivers.

Yours,
Linus Walleij
