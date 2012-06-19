Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2FSAQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:16:24 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:2853 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2FSAQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:16:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1340064959!5815269!17
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Date: Mon, 18 Jun 2012 19:16:10 -0500
Subject: RE: [PATCH 1/4] staging: comedi: Kconfig: menuconfig options should
 be bool not tristate
Thread-Topic: [PATCH 1/4] staging: comedi: Kconfig: menuconfig options
 should be bool not tristate
Thread-Index: Ac1NrloDx1Bx87PWSSiElq63QzltAwAAYB7w
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698DBD3D0@AUSP01VMBX24.collaborationhost.net>
References: <201206151520.04455.hartleys@visionengravers.com>
 <20120618235902.GA29679@kroah.com>
In-Reply-To: <20120618235902.GA29679@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 18, 2012 4:59 PM, Greg KH wrote:
> On Fri, Jun 15, 2012 at 03:20:04PM -0700, H Hartley Sweeten wrote:
>> The menuconfig options to enable the misc, isa, pci, pcmcia, and usb
>> comedi driver selections should be bool not tristate. They don't
>> directly affect the building of the kernel they just allow other
>> options to be selected.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
>> ---
>>  drivers/staging/comedi/Kconfig |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> This patch breaks the build for me with lots of the following errors:
> ERROR: "subdev_8255_init" [drivers/staging/comedi/drivers/adl_pci7296.ko] undefined!
> ERROR: "subdev_8255_cleanup" [drivers/staging/comedi/drivers/adl_pci7296.ko] undefined!

Strange. I just applied only this patch and the build still works
on my system. I don't see any reason why this change of the
menuconfig options from tristate to bool would cause the
problem you are seeing.

I do see a problem in the Kconfig for the adl_pci7296 driver.

Based on the error message above, it requires COMEDI_8255. But that
option is not listed as a depends or select. I noticed a couple other
comedi drivers with the same issue.

Regards,
Hartley



