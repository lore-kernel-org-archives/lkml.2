Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab1HBXGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 19:06:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36930 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab1HBXGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 19:06:43 -0400
Message-ID: <4E3882FE.6090108@lwfinger.net>
Date: Tue, 02 Aug 2011 18:06:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8192cu: add USB ID for Belkin n300 Micro USB wireless
 adapter
References: <201108022229.58532.s.L-H@gmx.de> <201108022243.04377.s.L-H@gmx.de> <4E386FB9.2040507@lwfinger.net> <201108030035.50214.s.L-H@gmx.de>
In-Reply-To: <201108030035.50214.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 05:35 PM, Stefan Lippers-Hollmann wrote:
> Hi
>
> On Wednesday 03 August 2011, Larry Finger wrote:
>> On 08/02/2011 03:43 PM, Stefan Lippers-Hollmann wrote:
>>> On Tuesday 02 August 2011, Stefan Lippers-Hollmann wrote:
> [...]
>>>> +	{RTL_USB_DEVICE(0x050D, 0x2103, rtl92cu_hal_cfg)}, //Belkin - Edimax
>
> Sorry about the C++ style comments, I meant to fix it, but forgot about
> it in the end.
>
> [...]
>>> [1]	http://aptosid.com/index.php?name=PNphpBB2&file=viewtopic&t=1550&start=0
>>> [2]	http://pastebin.com/ppZJ0GmU
>>
>> I have been holding a few new ID's that are in the vendor driver awaiting a
>> test. These include the following:
>>
>> +       {RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)},
>> +       {RTL_USB_DEVICE(0x13d3, 0x3357, rtl92cu_hal_cfg)}, /* AzureWave */
>> +       {RTL_USB_DEVICE(0x13d3, 0x3358, rtl92cu_hal_cfg)}, /*Azwave 8188CE-VAU*/
>> -       {RTL_USB_DEVICE(0x3359, 0x13d3, rtl92cu_hal_cfg)},
>> +       {RTL_USB_DEVICE(0x13d3, 0x3359, rtl92cu_hal_cfg)},
>> +       {RTL_USB_DEVICE(0x4855, 0x0090, rtl92cu_hal_cfg)}, /* Feixun */
>> +       {RTL_USB_DEVICE(0x4855, 0x0091, rtl92cu_hal_cfg)}, /* NetweeN-Feixun */
>> +       {RTL_USB_DEVICE(0x9846, 0x9041, rtl92cu_hal_cfg)}, /* Netgear Cameo */
>> +       {RTL_USB_DEVICE(0x050d, 0x2102, rtl92cu_hal_cfg)}, /*Belkin-Sercomm*/
>> +       {RTL_USB_DEVICE(0x050d, 0x2103, rtl92cu_hal_cfg)}, /*Belkin-Edimax*/
>>
>> The deleted entry has the vendor and product reversed. The first one in the list
>> has been tested and works.
>>
>> Based on your report, I will drop the 050d entries. If you get a confirmation
>> that 050d,2103 works, then submit that patch.
>
> I have now asked the reporter to check the state of rtl8192cu again,
> current state is (with a kernel including my original patch):
> - functionality confirmed on an unencrypted network
> - WPA2-psk not conclusively tested, it may be out of range for his device.
> ("EDIT: With my netbook I can get an IP address and use the neighbor's
>    unsecured network. Also, the Belkin device reports it at -47 dBm
>    signal strength, but my Toshiba netbook gives it -80 to -83 (which
>    may explain why the Belkin couldn't get an IP address), so there are
>    still some issues to sort.")
> - no Oops if his USB ID is compiled into the module, that only happens
>    if he tries to inject it into an unpatched kernel with:
>    echo -n "050d 2103">   /sys/bus/usb/drivers/rtl8192cu/new_id
>    (and I'm reluctant to raise this as potential issue completely, due
>    to the tainted kernel condition on his system).
>
> Hopefully he'll answer my further inquiries about the stability of his
> Belkin n300 Micro USB soon.

I think that ID and 050d:2102 should be added to the kernel. AFAIK, all 
RTL8192CU and all RTL8188CU chips are alike, at least as far as the programming 
is concerned. At least if the device works with the new IDs, it likely works as 
well as any other device. There are some reports of low performance from some 
models, but none of them crash Linux. In addition, there is no diagnostic info 
that would allow the debugging of the problem. My specific device does not show 
this problem.

As you have seen, I sent the patch for the others.

Larry
