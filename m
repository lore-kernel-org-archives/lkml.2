Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab2ESPss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 11:48:48 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:42882 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752477Ab2ESPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 11:48:45 -0400
Message-ID: <4FB7C0E4.4000008@xenotime.net>
Date: Sat, 19 May 2012 08:48:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        devel@driverdev.osuosl.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH -next] usb: add usb.h stubs for CONFIG_USB not enabled
References: <Pine.LNX.4.44L0.1205191026400.1348-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1205191026400.1348-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2012 07:30 AM, Alan Stern wrote:

> On Fri, 18 May 2012, Randy Dunlap wrote:
> 
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Add stubs for some usb core functions when CONFIG_USB
>> is not enabled.  This fixes these comedi build errors:
>>
>> ERROR: "usb_deregister" [drivers/staging/comedi/comedi.ko] undefined!
>> ERROR: "usb_register_driver" [drivers/staging/comedi/comedi.ko] undefined!
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> ---
>> I am only adding the stubs that are needed for comedi to build.
>> I expect that more stubs will be needed as more build errors are
>> found.  It seems to me that linux/usb.h might need more (major)
>> moving of lines to support more stubs in the future.
> 
> This doesn't seem like the right thing to do.  If a driver needs to 
> register with the USB core then that driver should depend on 
> CONFIG_USB.
> 
> On the other hand, if the driver is capable of being built without USB 
> support then it should use the necessary preprocessor tests to protect 
> calls to any USB routines.


Yeah, my first patch (not on linux-usb list) to staging/comedi/drivers.c
just surrounded the usb helper functions with IS_ENABLED(CONFIG_USB).
I'm fine with that patch, but Greg said that he wanted stubs...


-- 
~Randy
