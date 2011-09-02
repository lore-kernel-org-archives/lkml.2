Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1IBScM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:32:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34770 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab1IBScK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110823095938.GJ1341@legolas.emea.dhcp.ti.com>
References: <20110823150854.2f6da7f66247c3d31b07e072@canb.auug.org.au>
	<20110823095938.GJ1341@legolas.emea.dhcp.ti.com>
Date: Fri, 2 Sep 2011 20:32:09 +0200
X-Google-Sender-Auth: 0jcEjY0LWCQuHVWZpfUtY7mBZp4
Message-ID: <CAMuHMdWGtsNN3_26PZYOGQjDid4rXRxxssQVDCDsNSim_FJwdg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the moduleh tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: balbi@ti.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 11:59, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Aug 23, 2011 at 03:08:54PM +1000, Stephen Rothwell wrote:
>> After merging the moduleh tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/usb/dwc3/dwc3-pci.c: In function 'dwc3_pci_init':
>> drivers/usb/dwc3/dwc3-pci.c:211:9: error: 'THIS_MODULE' undeclared (first use in this function)
>>
>> Caused by the interaction of the module.h split up with commit
>> 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver") from the usb
>> tree.
>>
>> I have applied this patch for today (Greg, this should be applied to your
>> tree):
>>
>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date: Tue, 23 Aug 2011 15:05:25 +1000
>> Subject: [PATCH] usb: include module.h in the DesignWare USB3 DRD driver
>>
>> Fixes this build error:
>>
>> drivers/usb/dwc3/dwc3-pci.c: In function 'dwc3_pci_init':
>> drivers/usb/dwc3/dwc3-pci.c:211:9: error: 'THIS_MODULE' undeclared (first use in this function)
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>  drivers/usb/dwc3/dwc3-pci.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
>> index 2578595..e3b77d2 100644
>> --- a/drivers/usb/dwc3/dwc3-pci.c
>> +++ b/drivers/usb/dwc3/dwc3-pci.c
>> @@ -38,6 +38,7 @@
>>   */
>>
>>  #include <linux/kernel.h>
>> +#include <linux/module.h>
>
> that was my fault, I didn't know about Paul's commit. Please Greg, apply
> this to your tree:
>
> Acked-by: Felipe Balbi <balbi@ti.com>

The include should also be added to drivers/usb/dwc3/core.c and
drivers/usb/dwc3/dwc3-omap.c,
cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/4491952/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
