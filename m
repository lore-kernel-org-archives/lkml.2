Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1BXIIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:08:11 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32965 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab1BXIIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:08:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Slo7e3rYG6f6PnZfuwBL7Z9yUEAxQ4Cqm1YVYc3207XIVgYOdADV+KMxMFLfKlip+C
         oZANcS482dQTSDW5lO8XIwjvvMSa5s9UVdfIi24HISQHdgD7LWYKXmFkN/zWIuPuysbc
         asJhHh9lHkEZuU5jQxqi31YBMaD561cIU1Nek=
MIME-Version: 1.0
In-Reply-To: <20110223.235129.02262510.davem@davemloft.net>
References: <AANLkTikgDsM15DO7u2SP15xx=Y_pg6JdCLrie8ACobJP@mail.gmail.com>
 <20110131.203556.193730771.davem@davemloft.net> <AANLkTimorcNAEbSpuE_dUXKuOBZDcDcGSJ2cGefniThc@mail.gmail.com>
 <20110223.235129.02262510.davem@davemloft.net>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 24 Feb 2011 16:07:48 +0800
Message-ID: <AANLkTikE_OU_qiBUdiDP39js8jQzGqqo1FYW2uHmw3He@mail.gmail.com>
Subject: Re: [PATCH v4] net: add Faraday FTMAC100 10/100 Ethernet driver
To: David Miller <davem@davemloft.net>
Cc: mirqus@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, joe@perches.com,
        dilinger@queued.net, ratbert@faraday-tech.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, Feb 24, 2011 at 3:51 PM, David Miller <davem@davemloft.net> wrote:
> From: Po-Yu Chuang <ratbert.chuang@gmail.com>
> Date: Thu, 24 Feb 2011 15:27:55 +0800
>
>> I guess the problem is because a HW restriction that the rx buffer must be
>> 64 bits aligned. Since I cannot make rx buffer starts at offset 2 bytes, the
>> IP header, TCP header and data are not 4 bytes aligned. The performance
>> drops drastically.
>
> I cannot believe that after 20 years of commodity ethernet networking
> chips were first designed, people are still designing hardware that
> doesn't do this right.

Ha ha...
Well, this restriction was removed in the later IPs of our company. :-p

>
> Just emit garbage bytes into the sub-word alignment padding if the chip
> wants to word align it's DMA writes.

Not sure what do you mean. The problem is that HW does not accept a
base address of RX buffer which is not 8 bytes aligned.

> Even the 15 year old Dec Tulip chips do this properly.

best regards,
Po-Yu Chuang
