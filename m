Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab1CKOnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:43:31 -0500
Received: from smtp.nokia.com ([147.243.128.26]:61790 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab1CKOn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:43:28 -0500
Message-ID: <4D7A34F1.7070601@nokia.com>
Date: Fri, 11 Mar 2011 16:42:57 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: <andy.green@linaro.org>
CC: ext Andy Green <andy@warmcat.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <201103111331.13932.arnd@arndb.de> <4D7A191B.7040100@linaro.org>
In-Reply-To: <4D7A191B.7040100@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.1.90]
X-OriginalArrivalTime: 11 Mar 2011 14:42:59.0121 (UTC) FILETIME=[9DB9D210:01CBDFFA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/11/2011 02:44 PM, ext Andy Green wrote:

>
> I suggested this myself on #15 of the bug you linked to. However, it
> seems to me there is a generic issue here and it is not to do with
> whether stuff can be discovered on the bus or not; bugging the usbnet
> guys to accept devname-based commandline params and solving it for
> usbnet only would be covering up the actual issue.

I fail to see the problem. USB is a dynamically probed bus.
Whether the USB peripheral is hard-wired to the board or not, it is 
still dynamically probed. The board files are not expected to know 
anything about USB peripherals prior to enumeration, so platform data 
does not make sense for USB.

>
> The I2C implementation does not limit itself to providing I2C addresses
> and binding to driver names so it can be probed, it also provides for
> sending platform_data into the device when it is instantiated. That is
> very useful and I don't think the I2C guys will be accepting patches to
> remove that capability.

Platform data makes perfect sense for I2C because it is not a 
dynamically probed bus and board writers need to define which I2C chips 
are present on the board.

>
> There is no reason I can see that onboard USB assets should continue to
> be treated differently to miss out on the same capability because they
> are USB and not I2C, particularly as a permanently NULL platform_data
> pointer is already sitting there in the usb_device's .dev already
> exactly for this use.

What do you want to set in platform data? the ethernet device name? 
Isn't that better done in user space using udev rules?

-- 
regards,
-roger
