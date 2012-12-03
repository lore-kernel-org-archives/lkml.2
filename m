Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2LCNVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:21:12 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:41159 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab2LCNVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:21:11 -0500
Message-ID: <50BCA746.1020705@atmel.com>
Date: Mon, 3 Dec 2012 14:21:10 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Joachim Eastwood <manabian@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Havard Skinnemoen <havard@skinnemoen.net>
Subject: Re: [PATCH v2] net/macb: Use non-coherent memory for rx buffers
References: <CAGhQ9VwWmP_B17LnAEqDHcL8Yd-s0C-Bf35z3+=vnJmK_NoCSw@mail.gmail.com> <1354536876-6274-1-git-send-email-nicolas.ferre@atmel.com> <AE90C24D6B3A694183C094C60CF0A2F6026B70D5@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B70D5@saturn3.aculab.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 01:43 PM, David Laight :
>> Allocate regular pages to use as backing for the RX ring and use the
>> DMA API to sync the caches. This should give a bit better performance
>> since it allows the CPU to do burst transfers from memory. It is also
>> a necessary step on the way to reduce the amount of copying done by
>> the driver.
> 
> I've not tried to understand the patches, but you have to be
> very careful using non-snooped memory for descriptor rings.
> No amount of DMA API calls can sort out some of the issues.

David,

Maybe I have not described the patch properly but the non-coherent
memory is not used for descriptor rings. It is used for DMA buffers
pointed out by descriptors (that are allocated as coherent memory).

As buffers are filled up by the interface DMA and then, afterwards, used
by the driver to pass data to the net layer, it seems to me that the use
of non-coherent memory is sensible.

Do you still have reluctance with this patch?

Best regards,
-- 
Nicolas Ferre
