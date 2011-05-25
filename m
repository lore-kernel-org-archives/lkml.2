Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1EYJDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:03:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50171 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1EYJD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QUB4cBORJu8Sq1VPTsk8PIlwjBKTso65x4Sez6ELH3/J9fsHxu6AMMyABiRbSI7b8i
         HdWsi2++o0LvYi4QVElU8o2RcaUFmS2O0XIf6ibhKBgNzFptCmfyJMvIFHfQyFFYtRpU
         WhcLlCwL25JByhhIMkxoWYxaA3Ds8TSKXiTm4=
MIME-Version: 1.0
In-Reply-To: <201105221203.03970.arnd@arndb.de>
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com>
	<a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local>
	<BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>
	<201105221203.03970.arnd@arndb.de>
Date: Wed, 25 May 2011 11:03:28 +0200
X-Google-Sender-Auth: eH-4nSMgxPux9b_Qjt2-KjHcENk
Message-ID: <BANLkTinrBgA8Zw03AzGFxAiY-84Hgxfcxg@mail.gmail.com>
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>
Cc: Kevin Hilman <khilman@ti.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/22 Arnd Bergmann <arnd@arndb.de>:
> On Saturday 21 May 2011 19:42:34 Grant Likely wrote:
>> 1) drop amba-bus entirely and use platform_device everywhere, similar
>> to what OMAP has done
>> 2) strictly create amba_devices for nodes compatible with "arm,amba-device"
>> 3) be intelligent about amba device creation; create an amba_device
>> only for devices we know are driven with amba_driver.
>
> Or maybe
>
> 4) Use amba_device for all devices on an amba bus (identified by
> the compatible property of the bus), but mark the ones that do
> not have primecell compatible registers so that the amba bus
> does not try to look at them but instead takes the information
> from the device tree.

Currently the amba/primecell bus driver in drivers/amba/bus.c
will have the hardware registers override any data provided
from the board.

There are pending patches to instead have the board potentially
override the hardware, see:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6829/1

The reason is that some of our hardware has newer revisions
of the PrimeCells and still the hardware registers have not
been updated properly. (Yes, the people involved have been
informed.)

So you also have a case where you may want to provide an ID
and have it override the ID present in the hardware.

Yours,
Linus Walleij
