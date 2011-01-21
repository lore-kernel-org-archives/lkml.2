Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1AUDhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 22:37:52 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63095 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab1AUDhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 22:37:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DNpAll7Z2qaA8C8KWlwI+SirXvw9BRftg/mNZSS9JAp34ZTSs5qJw8Px9qa1JxADrP
         Kf4Edjda4bdD6HoAshMJn6mSGdh+8cTY/VtNeBQij84Ul0ToAnoX1xHzHAo8B6JJUsJF
         cKAmWj0WA4/o8chlW2KIjVv1tcyaGUNMlbg3k=
MIME-Version: 1.0
In-Reply-To: <AANLkTimFcEC0oXJGnJ7HQKLB9thfuWHeWSYSMCGR=hWJ@mail.gmail.com>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com> <AANLkTimFcEC0oXJGnJ7HQKLB9thfuWHeWSYSMCGR=hWJ@mail.gmail.com>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 21 Jan 2011 11:37:29 +0800
Message-ID: <AANLkTimSXZ_jk1PvAqzTWbr1b+GS6Y=m6zcSPaARp7dP@mail.gmail.com>
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, joe@perches.com,
        dilinger@queued.net, Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Michał ,

2011/1/21 Michał Mirosław <mirqus@gmail.com>:
> 2011/1/20 Po-Yu Chuang <ratbert.chuang@gmail.com>:
> [...]
>> +/******************************************************************************
>> + * internal functions (receive descriptor)
>> + *****************************************************************************/
>> +static bool ftmac100_rxdes_first_segment(struct ftmac100_rxdes *rxdes)
>> +{
>> +       return le32_to_cpu(rxdes->rxdes0) & FTMAC100_RXDES0_FRS;
>> +}
>> +
>> +static bool ftmac100_rxdes_last_segment(struct ftmac100_rxdes *rxdes)
>> +{
>> +       return le32_to_cpu(rxdes->rxdes0) & FTMAC100_RXDES0_LRS;
>> +}
>> +
> [...]
>
> You can change these and similar functions to use:
>
> rxdes->rxdes0 & cpu_to_le32(FTMAC100_RXDES0_LRS)
>
> This will be subject to constant folding by compiler and produce
> better code for big-endian arches.

Fixed. It looks much better now.
Thanks a lot.

best regards,
Po-Yu Chuang
