Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1LUMGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:06:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37263 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1LUMGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:06:33 -0500
Message-ID: <4EF1CB8A.10309@mvista.com>
Date: Wed, 21 Dec 2011 16:05:30 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
Subject: Re: [PATCH v2] davinci: DA850 EVM: OHCI platform code
References: <1324452002-8388-1-git-send-email-prakash.pm@ti.com> <DF0F476B391FA8409C78302C7BA518B6051CB9@DBDE01.ent.ti.com>
In-Reply-To: <DF0F476B391FA8409C78302C7BA518B6051CB9@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-12-2011 13:56, Nori, Sekhar wrote:

> On Wed, Dec 21, 2011 at 12:50:02, Manjunathappa, Prakash wrote:
>> From: Ajay Kumar Gupta<ajay.gupta@ti.com>

>> On this board the OHCI port's power control and over-current signals from
>> TPS2065 power switch are connected via GPIO2[4] and GPIO6[13] respectively,
>> so we can implement the DA8xx OHCI glue layer's hooks for overriding the
>> root hub port's power and over-current status bits.

>> We also have to properly set up the clocking mode in the CFGCHIP2 register,
>> so that internal 24 MHz reference clock is fed to the USB 2.0 (MUSB) PHY and
>> its output is used to clock the USB 1.1 (OHCI) PHY...

>> Signed-off-by: Ajay Kumar Gupta<ajay.gupta@ti.com>
>> Signed-off-by: Manjunathappa, Prakash<prakash.pm@ti.com>

> This is the third copy of OHCI platform setup code which is almost
> the same except for the GPIO numbers.

    Well, in my counting, it's only second, DA830 EVM being the first one.
What's the third?

> Can we attempt to consolidate
> the GPIO case under drivers/usb/host/ohci-da8xx.c glue layer itself?
> Of course, here should be a provision for non-GPIO based implementation
> as well.

> Sergei, any thoughts, comments?

    I designed the hub interface to be as abstract as I could, and now you're 
proposing to add GPIO to it? No, I have no clear idea how to keeep it abstract 
and add GPIO support at the same time. I would have been grateful to
TI if I didn't have to invent this at all and they stop saving on OHCI pins.

> Thanks,
> Sekhar

WBR, Sergei
