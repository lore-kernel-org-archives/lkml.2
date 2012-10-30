Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178Ab2J3SWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:22:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59367 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759674Ab2J3SWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:22:52 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:2602:baac:6fff:fe8c:a1a5]
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B707D@saturn3.aculab.com>
References: <cover.1351591858.git.nicolas.ferre@atmel.com>
	<75eb5df193c504e68ebff7d6a6a88d9a1cc678cb.1351591858.git.nicolas.ferre@atmel.com>
	<AE90C24D6B3A694183C094C60CF0A2F6026B707D@saturn3.aculab.com>
Date: Tue, 30 Oct 2012 11:22:51 -0700
Message-ID: <CACiLriQnQcoXFqrqNt3nkY47nR8FnXbqWjtPRp250gueHSMDmQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/10] net/macb: clean up ring buffer logic
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <havard@skinnemoen.net>
To: David Laight <David.Laight@aculab.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        davem@davemloft.net, bhutchings@solarflare.com,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
        manabian@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 4:12 AM, David Laight <David.Laight@aculab.com> wrote:
>> Instead of masking head and tail every time we increment them, just let them
>> wrap through UINT_MAX and mask them when subscripting. Add simple accessor
>> functions to do the subscripting properly to minimize the chances of messing
>> this up.
> ...
>> +static unsigned int macb_tx_ring_avail(struct macb *bp)
>> +{
>> +     return TX_RING_SIZE - (bp->tx_head - bp->tx_tail);
>> +}
>
> That one doesn't look quite right to me.
> Surely it should be masking with 'TX_RING_SIZE - 1'

Why is that? head and tail can never be more than TX_RING_SIZE apart,
so it shouldn't make any difference.

Havard
