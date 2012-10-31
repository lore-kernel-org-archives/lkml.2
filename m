Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2JaJju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:39:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:20480 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2JaJjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:39:46 -0400
Message-ID: <5090FFF5.6020109@atmel.com>
Date: Wed, 31 Oct 2012 11:39:49 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <havard@skinnemoen.net>,
        David Laight <David.Laight@aculab.com>
CC: <netdev@vger.kernel.org>, <manabian@gmail.com>,
        <patrice.vilchez@atmel.com>, <linux-kernel@vger.kernel.org>,
        <bhutchings@solarflare.com>, <plagnioj@jcrosoft.com>,
        <davem@davemloft.net>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 06/10] net/macb: clean up ring buffer logic
References: <cover.1351591858.git.nicolas.ferre@atmel.com> <75eb5df193c504e68ebff7d6a6a88d9a1cc678cb.1351591858.git.nicolas.ferre@atmel.com> <AE90C24D6B3A694183C094C60CF0A2F6026B707D@saturn3.aculab.com> <CACiLriQnQcoXFqrqNt3nkY47nR8FnXbqWjtPRp250gueHSMDmQ@mail.gmail.com> <5090F67C.9020104@atmel.com>
In-Reply-To: <5090F67C.9020104@atmel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 10:59 AM, Nicolas Ferre :
> On 10/30/2012 07:22 PM, Håvard Skinnemoen :
>> On Tue, Oct 30, 2012 at 4:12 AM, David Laight <David.Laight@aculab.com> wrote:
>>>> Instead of masking head and tail every time we increment them, just let them
>>>> wrap through UINT_MAX and mask them when subscripting. Add simple accessor
>>>> functions to do the subscripting properly to minimize the chances of messing
>>>> this up.
>>> ...
>>>> +static unsigned int macb_tx_ring_avail(struct macb *bp)
>>>> +{
>>>> +     return TX_RING_SIZE - (bp->tx_head - bp->tx_tail);
>>>> +}
>>>
>>> That one doesn't look quite right to me.
>>> Surely it should be masking with 'TX_RING_SIZE - 1'
>>
>> Why is that? head and tail can never be more than TX_RING_SIZE apart,
>> so it shouldn't make any difference.
> 
> Absolutely.

Well not so absolute, after having thinking twice ;-)

We should move to:

static unsigned int macb_tx_ring_avail(struct macb *bp)
{
	return (TX_RING_SIZE - (bp->tx_head - bp->tx_tail) & (TX_RING_SIZE - 1));
}

Thanks David!

(sorry for the noise) Bye,
-- 
Nicolas Ferre
