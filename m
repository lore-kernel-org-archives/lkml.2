Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab2GBJtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:49:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:36779 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717Ab2GBJtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:49:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120702072445.GD16670@arwen.pp.htv.fi>
References: <1340722608-997-1-git-send-email-aletes.xgr@gmail.com>
	<20120702072445.GD16670@arwen.pp.htv.fi>
Date: Mon, 2 Jul 2012 06:49:44 -0300
Message-ID: <CAAAP30HVO25GHJpwXrfjb1JLenMq9COJ-mXUPYLEV2jy-w_-7w@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: Fix Kconfig dependency for Phy drivers
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: balbi@ti.com
Cc: Roland Stigge <stigge@antcom.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012 at 4:24 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Jun 26, 2012 at 11:56:48AM -0300, Alexandre Pereira da Silva wrote:
>> USB phy layer driver are only built if usb host is selected, but they
>> are used too by USB_GADGET drivers
>>
>> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>> ---
>>  drivers/usb/Makefile    |    2 +-
>>  drivers/usb/phy/Kconfig |    4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
>> index c691eea..f5ed3d7 100644
>> --- a/drivers/usb/Makefile
>> +++ b/drivers/usb/Makefile
>> @@ -46,7 +46,7 @@ obj-$(CONFIG_USB_MICROTEK)  += image/
>>  obj-$(CONFIG_USB_SERIAL)     += serial/
>>
>>  obj-$(CONFIG_USB)            += misc/
>> -obj-$(CONFIG_USB)            += phy/
>> +obj-$(CONFIG_USB_COMMON)     += phy/
>
> I'm not sure this is the best solution. Should we introduce
> CONFIG_USB_PHY for this ?

In my opinion, the right solution is to move the ISP1301 to the otg
dir, where it belongs and merge the duplicated code from lpc32xx_udc
and ohxi-nxp to it.

I suggest to leave this as is for now, as it's preventing the driver
to build in some configurations. Later, we can try to move this to the
right place.
