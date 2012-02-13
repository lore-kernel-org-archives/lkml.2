Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2BMA0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 19:26:43 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56049 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757Ab2BMA0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 19:26:42 -0500
Message-ID: <4F3858BD.3040707@lwfinger.net>
Date: Sun, 12 Feb 2012 18:26:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: chunkeey@web.de, m@bues.ch, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] p54spi: Convert driver to use asynchronous firmware
 loading
References: <4f346d61.3S6x22TS5RH2gGO5%Larry.Finger@lwfinger.net> <CAMo8BfL+nbOmO=jo1uqYoXOUCDW2-c7BZTL5UBcdHGuyGODiFA@mail.gmail.com>
In-Reply-To: <CAMo8BfL+nbOmO=jo1uqYoXOUCDW2-c7BZTL5UBcdHGuyGODiFA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2012 06:20 PM, Max Filippov wrote:
>> Drivers that load firmware from their probe routine have problems with the
>> latest versions of udev as they get timeouts while waiting for user
>> space to start. The problem is fixed by using request_firmware_nowait()
>> and delaying the start of mac80211 until the firmware is loaded.
>>
>> To prevent the possibility of the driver being unloaded while the firmware
>> loading callback is still active, a completion queue entry is used.
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>> ---
>>
>> This conversion of p54spi to use asynchronous firmware loading is based
>> on the method used in p54usb. As I do not have the hardware, it is only
>> compile tested. I would appreciate any feedback from people that have the
>> hardware.
>
> Hi, Larry.
>
> Are there any prerequisites for this patch?
> For now I'm applying it to the linux-omap ToT and having the following:

No, there are no prerequisites; however, as Michael Buesch noted, I missed the 
eeprom loading. This patch will not work.

I am currently testing an approach that is much simpler. Rather than using 
request_firmware_nowait(), I am having the probe routine start a work queue, and 
let that routine do a normal request_firmware(). This form of the patch is a lot 
less intrusive.

I hope to post a revised patch within a day.

Thanks for testing.

Larry




