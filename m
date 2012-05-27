Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2E0LuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 07:50:05 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:18636 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2E0LuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 07:50:03 -0400
Message-ID: <4FC214E5.1010007@atmel.com>
Date: Sun, 27 May 2012 13:49:57 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: <herbert@gondor.hengli.com.au>, <jamie@jamieiles.com>,
        <linux-kernel@vger.kernel.org>, <GPontis@z9.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] hw_random: atmel-rng: fix race condition leading to repeated
 bits
References: <1337937158-9710-1-git-send-email-jacmet@sunsite.dk> <4FBF5916.4070705@atmel.com> <877gw0a7vc.fsf@macbook.be.48ers.dk>
In-Reply-To: <877gw0a7vc.fsf@macbook.be.48ers.dk>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.48.186]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 12:10 PM, Peter Korsgaard :
>>>>>> "Nicolas" == Nicolas Ferre <nicolas.ferre@atmel.com> writes:
> 
> Hi,
> 
>  Nicolas> What about a single read to ISR like this:
> 
>  Nicolas> tmp = readl(trng->base + TRNG_ODATA);
>  Nicolas> if (readl(trng->base + TRNG_ISR) & 1) {
>  Nicolas> 	*data = tmp;
>  Nicolas> 	return 4;
>  Nicolas> } else {
>  Nicolas>   	return 0;
>  Nicolas> }
> 
> No, that won't work as you then have another race. Data might not be
> ready when you read ODATA, but then become ready just in time for when
> you read ISR, so you end up using stale data.

Yes, sure.

> It all would have been easier if the ready bit would get cleared on
> reads from ODATA instead of/as well as from ISR, but that's
> unfortunately not the case.

I will talk about that idea to my friends designers and see if we can
improve things, in the future...

Thanks, bye,
-- 
Nicolas Ferre
