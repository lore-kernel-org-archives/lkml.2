Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab2I1NbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:31:09 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51583 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240Ab2I1NbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:31:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120928125758.GK31006@arwen.pp.htv.fi>
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
	<1348836795-4783-2-git-send-email-kishon@ti.com>
	<20120928125758.GK31006@arwen.pp.htv.fi>
Date: Fri, 28 Sep 2012 19:01:04 +0530
Message-ID: <CAAe_U6JX8nqhZU-m+0Cfh1-xEkZhXNf2ecYcg_JX9mx5fv1b3A@mail.gmail.com>
Subject: Re: [PATCH 1/6] usb: dwc3-omap: use of_platform API to create dwc3
 core pdev
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 28, 2012 at 6:27 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Sep 28, 2012 at 06:23:10PM +0530, Kishon Vijay Abraham I wrote:
>> Used of_platform_populate() to populate dwc3 core platform_device
>> from device tree data. Since now the allocation of unique device id is
>> handled be of_*, removed the call to dwc3_get_device_id.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> I think it's best if you split the use of device_for_each_child() from
> this patch. So first do the device_for_each_child() part, then later use
> of_platform_populate().

I think it's better to have it both together as of_platform_populate
will create the device and the device_for_each_child() part will
delete it on error conditions and during driver removal.
In this patch the first device_for_each_child() comes in error
condition and it is not needed if we have not created the device using
of_platform_populate.

Thanks
Kishon
