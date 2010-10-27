Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002Ab0J0L4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:56:45 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:56535 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab0J0L4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:56:44 -0400
X-Auth-Info: OWJSMPIYIPIsNzLKlwTF+pEiFioxwRVvCDa1iENRmWM=
Message-ID: <4CC813B9.3080506@grandegger.com>
Date: Wed, 27 Oct 2010 13:57:45 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Marc Kleine-Budde <mkl@pengutronix.de>, andrew.chih.howe.khor@intel.com,
        masa-korg@dsn.okisemi.com, sameo@linux.intel.com,
        margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        socketcan-core@lists.berlios.de, kok.howg.ewe@intel.com,
        joel.clark@intel.com, morinaga526@dsn.okisemi.com,
        David Miller <davem@davemloft.net>, chripell@fsfe.org,
        qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix	buildwarnings
References: <4CC61B1B.3090602@dsn.okisemi.com>	<20101026.105206.15244527.davem@davemloft.net>	<20101026.105545.200376685.davem@davemloft.net><4CC71DA4.3020600@grandegger.com>	<4CC72360.1070608@pengutronix.de> <008201cb75c9$f27ff720$66f8800a@maildom.okisemi.com>
In-Reply-To: <008201cb75c9$f27ff720$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 01:27 PM, Tomoya MORINAGA wrote:
> On Wednesday, October 27, 2010 3:52 AM :  Marc Kleine-Budde and Wolfgang Grandegge wrote:
> 
> The following is some inarticulate points I have for your questions.
> Please give me more information.
> 
>> Do I understand your code correctly? You have a big loop, but only do
>>  two different things at certain values of the loop? Smells fishy.
> Uh, I can't understand your intention.
> Please show in detail.
> This processing does configuration for all message objects.

Not all, but just a few of them. We believe it can be implemented more
efficiently.

> 
>> what does this loop do? why is it nessecarry? I don't like delay loops
>>   in the hot path of a driver.
> This loop is for waiting for all tx Message Object completion.
> This is Topcliff CAN HW specification.

What do you mean with "tx Message Object completion"? Is TX done not
signaled via interrupt? Please explain why you need to wait multiples of
500us here in the hot TX path.

>> If you figured out how to use the endianess conversion functions from
>> the cpu_to_{le,be}-{le,to}_to_cpup family use them here, too.
> Uh,le32_to_cpu have been used already here.
> I can't understand your intention.
> Please show in detail.
> 
> 
>>> All these check if busy in the code make me a bit nervous, can you
>>> please explain why they are needed. A pointer to the manual is okay, too.
>> Me too. I already ask in my previous mail how long that functions
>> usually blocks.
> When accessing read/write from/to Message RAM,
> Since it takes much time for transferring between Register and Message RAM,

Much time means how many mirco-seconds?

> SW must check busy flag of CAN register.
> This is a Topcliff HW specification.

Maybe the busy check could also be done *before* the Message RAM is
accessed to avoid (or minimize) waiting.

>> is there some pdev->name instead of KBUILD_MODNAME that can be used?
> I can't understand your intention.
> pdev(struct pci_dev) doesn't have "name" member. 
> Please show in detail.

Using KBUILD_MODNAME is OK. It does hold the name of the driver as required.

Wolfgang.


