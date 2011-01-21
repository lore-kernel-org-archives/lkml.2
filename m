Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1AUHHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:07:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35624 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab1AUHG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HIMa2yDsx4kJWhU52JMXNQwN4zRHA+E0jCQ2yFS1zui+aOPSYoLo74z9OEn65ilbnv
         sSrsGtiBw7rB09252+c/J+GuBGYBLGmyxLikBK7JZcRe1lEZhyEKeVmOfmArTKsUKK8p
         lst10psjU6ly+13RsS4CnJtHF2Cb4UrpUc+xE=
MIME-Version: 1.0
In-Reply-To: <1295592411.6795.10.camel@Joe-Laptop>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com>
 <1295550009.28001.59.camel@Joe-Laptop> <AANLkTi=b9ma=xV1ovbJmy94BrDT696VR4OcyR9vqwGtB@mail.gmail.com>
 <1295592411.6795.10.camel@Joe-Laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 21 Jan 2011 15:06:37 +0800
Message-ID: <AANLkTimwcWtmftfwXBFfFG+bUNxNSJqNVnyvU_oWsyNL@mail.gmail.com>
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, eric.dumazet@gmail.com, dilinger@queued.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Joe,

On Fri, Jan 21, 2011 at 2:46 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2011-01-21 at 13:03 +0800, Po-Yu Chuang wrote:
>> > Is it useful to retry the NORXBUF case?
>> The idea is that if I miss packet finished interrupts (then rx buffers used up),
>> I should retrieve the received packets ASAP to free buffers to HW.
>> Maybe this is really unnecessary.
>> I am not quite sure, but I'll do your advice now.
>
> I wasn't giving advice, just asking a question.
> Your concept makes sense to me.

I see. So I will leave it as is.

>> >> +     if (status & FTMAC100_INT_NORXBUF) {
>> >> +             /* RX buffer unavailable */
>> >> +             if (net_ratelimit())
>> >> +                     netdev_info(netdev, "INT_NORXBUF\n");
>> >> +
>> >> +             netdev->stats.rx_over_errors++;
>> >> +     }
>> >
>> > Perhaps this "if (status & FTMAC100_INT_NORXBUF)" block should be
>> > moved into the test block above it before the retry?
>>
>> Since status is not changed in the function, it does not matter where
>> the test is.
>> But I agree that it is better to handle error cases earlier.
>
> This wasn't so much a handle error case early, but
> a suggestion that
>        if (status & (foo | bar)) {
>                ...
>        }
>        if (status & bar) {
>                ...
>        }
> should be
>        if (status & (foo | bar)) {
>                ...
>                if (status & bar) {
>                        ...
>                }
>        }
>
> so that when the first test fails, a known
> subset of the first test isn't tested again.

Understand. Thanks.

best regards,
Po-Yu Chuang
