Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2CBFZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:25:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9013 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2CBFZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:25:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 01 Mar 2012 21:25:06 -0800
Message-ID: <4F505972.1020203@nvidia.com>
Date: Fri, 2 Mar 2012 10:54:02 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "kyle.manna@fuel7.com" <kyle.manna@fuel7.com>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1] input: keyboard: Add interrupt keyboard driver.
References: <1326778915-2678-1-git-send-email-ldewangan@nvidia.com> <20120119072941.GA9668@core.coreip.homeip.net> <AE833E40769D9441BEBD31E18A33543503A71ECB3B@BGMAIL01.nvidia.com> <4F20B651.4050609@nvidia.com>
In-Reply-To: <4F20B651.4050609@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 January 2012 07:41 AM, Laxman Dewangan wrote:
> On Thursday 19 January 2012 01:09 PM, Laxman Dewangan wrote:
>> On Thursday, January 19, 2012 1:00 PM, Dmitry Torokhov wrote:
>>
>>
> Hi  Dmitry,
> Do you have any further comment on above approach?  Here is little bit
> background which can help on understanding.
> I am working on some MFD devices and to tried to support the onkey from
> single driver to avoid having driver for each mfd-pmic driver.
>
> When developing this driver, I though of following behaviors of the pmic
> device for power-btn/onkey switches:
> 1. Separate Interrupt for press and release: (Falling and rising
> interrupt, no level interrupt) So two different interrupt will get
> registered and based on interrupt number the key code and key value will
> get reported to input system. Device like AB8500 (ab8500-ponkey.c).
>
> 2. Generates interrupt for only key press, no interrupt for the key
> release (only one interrupt i.e. Falling edge) In this case, it need to
> send the release event automatically after sending press event. So
> whenever there is falling edge on keys, the interrupt get generated, No
> interrupt on pressed level. Devices like ricoh583,  max77663.
>
> 3. Keep generating interrupt if key is pressed but no interrupt after
> release (Kind on level (low) interrupt and so multiple interrupts till
> key pressed.) Devices like tps65910..
> In this case, the device generates level interrupt and if it acked,
> again generates interrupt. So if we send the key press/release together
> without waiting, we will endup with sending the key event multiple time.
> To avoid this I used the debaince logic as follows:
> detect first interrupt, send press event and start timer and wait for
> timer to expire for sending release events. If interrupt again occurs
> before timer expires, restart timer again. Keep doing this until user
> release the key. Once he release the key, there will be no interrupt and
> so timer will be expire after some time i.e. debounce time and then
> report key released.
>
>

Hi Dmitry,
Can you please review the above approach? If you still want to do in 
gpio-keys then I will make new patch and will send but wanted to know 
your opinion about my proposals.
Idea is to get support only interrupt keys.

Thanks,
Laxman
