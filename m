Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1ELHCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:02:13 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33371 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab1ELHCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:02:11 -0400
X-Auth-Info: DhZHeRzO88UMSloZAM3KeYokjnQ8HgOFKFEs5NQNJ9o=
Message-ID: <4DCB8688.7070400@grandegger.com>
Date: Thu, 12 May 2011 09:04:40 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>	<20110510112734.54160824@lxorguk.ukuu.org.uk>	<2BFFDAA0A0DE4820876E5549867938EC@subhasishg> <201105112331.47954.arnd@arndb.de>
In-Reply-To: <201105112331.47954.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 11:31 PM, Arnd Bergmann wrote:
> On Tuesday 10 May 2011, Subhasish Ghosh wrote:
>>
>>>> Yes, In case if we allow the ALL implementation, it hogs the CPU.
>>>> In that case we do not need the PRU. The whole purpose of the PRU
>>>> is to offload the processor for any such implementations. 
>>>
>>> So the kernel presumably needs to switch between using the PRU and native
>>> according to the number of ids being requested at the time ?
>>
>> All the IDs are programmed into the PRU data RAM.
>> The Kernel receives interrupts based upon these IDs.
>> I could not clearly follow "PRU and native", could you please elaborate.
> 
> We would really like all CAN drivers to behave the same way. All other
> drivers are able to work without filters, so pruss_can should allow that
> too, even if it becomes a CPU hog at that time.
> 
> It seems to me that the pruss can implementation has one thing backwards:
> it assumes a specific usage model for CAN that it is trying to do offload
> for. However, that usage model is currently not even supported by Socket
> CAN. If I understand Wolfgang correctly, it is in fact considered an
> unwanted limitation of the pruss can driver, instead of a useful feature.

"Unwanted" is not the right word. I see it as a piece of CAN hardware
with some serious limitations and I doubt that it will make real CAN
users happy. But well, I might be wrong.

> If that interpretation is right, I would seriously recommend rethinking
> the design of the CAN firmware for pruss, so you can start doing something
> useful with the offload engine that fits into the Socket CAN API, or that
> would be a useful extension to Socket CAN that is also implementable in
> the kernel for all other drivers in a meaningful way.

It would be really nice if they could provide a better firmware. Anyway,
the generic CAN hardware filter interface we spoke about in a previous
mail would fit for the PRUSS CAN hardware as well. It just needs to be
implemented.

Wolfgang.
