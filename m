Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1CKPvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:51:17 -0500
Received: from smtp.nokia.com ([147.243.1.47]:40226 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632Ab1CKPvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:51:16 -0500
Message-ID: <4D7A44E0.5080605@nokia.com>
Date: Fri, 11 Mar 2011 17:50:56 +0200
From: Roger Quadros <roger.quadros@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: ext Arnd Bergmann <arnd@arndb.de>
CC: <andy.green@linaro.org>, ext Andy Green <andy@warmcat.com>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <4D7A191B.7040100@linaro.org> <4D7A34F1.7070601@nokia.com> <201103111622.10722.arnd@arndb.de>
In-Reply-To: <201103111622.10722.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.1.90]
X-OriginalArrivalTime: 11 Mar 2011 15:50:57.0580 (UTC) FILETIME=[1CAD46C0:01CBE004]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/11/2011 05:22 PM, ext Arnd Bergmann wrote:
> On Friday 11 March 2011, Roger Quadros wrote:
>>> There is no reason I can see that onboard USB assets should continue to
>>> be treated differently to miss out on the same capability because they
>>> are USB and not I2C, particularly as a permanently NULL platform_data
>>> pointer is already sitting there in the usb_device's .dev already
>>> exactly for this use.
>>
>> What do you want to set in platform data? the ethernet device name? 
>> Isn't that better done in user space using udev rules?
> 
> A udev rule would solve the problem at hand, but I'd consider that
> an ugly workaround as well. The naming in the kernel is really
> bogus -- any USB device that has a fixed address gets treated
> as eth0, while others become usb0, with the same driver,
> see the code fragment below.

but isn't that sensible? a real ethernet hardware will have a MAC
address. no?

> The most simple way to solve this particular problem is to
> remove the check for "net->dev_addr [0] & 0x02", which only
> has any effect on the smsc75xx and smsc95xx drivers, both of
> which are for real ethernet devices, not point-to-point
> USB links.
> 
> That would however still leave the problem of the missing
> mac address, which is not good if you want to work with the
> system using dhcp.

The USB ethernet peripheral does not have a globally unique MAC ??

-- 
regards,
-roger
