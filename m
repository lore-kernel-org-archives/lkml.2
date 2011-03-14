Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab1CNIQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 04:16:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62115 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1CNIQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 04:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wZcspVFmMSHCdBhbtw1i44aiHiwJh1VnzFm6MkIhAd0oqQP2yeQQCFDUVhYpRB5stE
         ogz85VDuWz6rf9luxVo6k4BmdL6ZL81fR0S8MYbOWmZ3/WakxlkQnlxpOM919Gbwf8WO
         tVuX+Tt9OsXQj4HneyaPZ6D6qyseNxf0AKuKI=
MIME-Version: 1.0
In-Reply-To: <1300048193.2761.55.camel@edumazet-laptop>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
 <1300047388.2761.48.camel@edumazet-laptop> <1300048002.2761.53.camel@edumazet-laptop>
 <1300048193.2761.55.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Mon, 14 Mar 2011 16:16:06 +0800
Message-ID: <AANLkTi=grwkfYpBFJEyQHXbFaTov5Tc+tAR2ebzw0Bht@mail.gmail.com>
Subject: Re: [PATCH net-next-2.6] ftmac100: use GFP_ATOMIC allocations where needed
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Mon, Mar 14, 2011 at 4:29 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le dimanche 13 mars 2011 à 21:26 +0100, Eric Dumazet a écrit :
>> Le dimanche 13 mars 2011 à 21:16 +0100, Eric Dumazet a écrit :
>>
>> > BTW, it seems I missed the fact that ftmac100_alloc_rx_page() used a
>> > GFP_KERNEL allocation, while its called from softirq context (from
>> > ftmac100_rx_packet())
>>
>> Here is a patch against ftmac100
>>
>
> Oops, one typo in it sorry
>
>> -static int ftmac100_alloc_rx_page(struct ftmac100 *priv, struct ftmac100_rxdes *rxdes)
>> +static int ftmac100_alloc_rx_page(struct ftmac100 *priv,
>> +                               struct ftmac100_rxdes *rxdes, gtp_t gfp)
>
> Should be :   gfp_t gfp
>
> Please build and test the patch, I dont have an ARM testbed anyway.

Tested-by: Po-Yu Chuang <ratbert@faraday-tech.com>

Thank you,
Po-Yu Chuang
