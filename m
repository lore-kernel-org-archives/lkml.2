Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1LJUKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 15:10:50 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:47955 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab1LJUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 15:10:49 -0500
X-manitu-Original-Sender-IP: 79.230.61.111
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <4EE3BCB4.7060401@grandegger.com>
Date: Sat, 10 Dec 2011 21:10:28 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] flexcan: Acknowledge all interrupt sources in the IRQ
 handler
References: <1323438454-6816-1-git-send-email-LW@KARO-electronics.de>	<4EE212AE.40005@pengutronix.de> <20194.5210.650914.867608@ipc1.ka-ro> <4EE21C96.5010604@grandegger.com>
In-Reply-To: <4EE21C96.5010604@grandegger.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 03:35 PM, Wolfgang Grandegger wrote:
> On 12/09/2011 02:59 PM, Lothar Waßmann wrote:
>> Hi,
>>
>> Marc Kleine-Budde writes:
>>> On 12/09/2011 02:47 PM, Lothar Waßmann wrote:
>>>> Otherwise the handler will get stuck in an endless IRQ loop when an
>>>> interrupt condition occurs that is not being acked (e.g. TWRN)
>>>
>>> On which CPU do you have this problem?
>>>
>> on i.MX28.
> 
> Yes, it is definitely needed on i.MX28 and I already have it in my
> series. See:
> 
> https://gitorious.org/~wgrandegger/linux-can/wg-linux-can-next/commit/8ad94fa0dd7f7728824fa8fd4479390ac3f189c7
> 
> BTW: at similar patch was already sent by Reuben Dowle.
> 
>>> Seems that mx25/35 behave a bit different than mx28. But I had no time
>>> to dig into this, yet. BTW Wolfgang is just reworking error handling,
>>> can you please test his patches he recently posted on linux-can.
>>>
>> The ESR of i.MX25 is completely identical to the i.MX28.
>> You should be able to reproduce the problem when trying to send a
>> message to a CAN interface with the transceiver disabled.
>> You will get a BIT0_ERR and the TWRN bit will be asserted and never
>> cleared leading to an endless interrupt loop.
> 
> If you are right, the code was never working on i.MX25/35... which I doubt.

I know remember that the old code was working on a MX35PDK board.
Actually I did the porting some time ago. That means that we have to
deal with two variants of the Flexcan controller, unfortunately:

mx25/35: State changes *and* bus errors are both signalled via ESR ERR
	bit. The TWRN, RWRN and BOFF bits seem not to be used. Therefore
	bus error reporting cannot be enabled/disabled individually.

mx28/mx53?: Bus error are signalled via ESR ERR bit and state changes
	via TWRN, RWRN and BOFF bit. Therefore bus error reporting
	*can* be enabled/disabled individually as implemented by this
	patch:

	https://gitorious.org/~wgrandegger/linux-can/wg-linux-can-next/commit/f0829d269a451c8abb99435d5a1a63cb18566668

I will try to get a MX35PDK board for further evaluation and development.

Wolfgang.

