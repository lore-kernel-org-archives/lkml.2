Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab0HKBk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:40:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63823 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab0HKBk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D1UI4rd2XrP6oyPlbOblaz3K9U9vqnqd+OhKZdO8rm9mu7SLFQFC42fc0H6Xq4eL3o
         IxnMlEQ8RGJ/vcfcUI2LXR7IpuD7W7OylG3r5ZQ7kfZ0HZHp7aCwc5n1dUWYMw+miI/g
         v9vzF0BSHlcdGuYlD8rSH4jVvMmFd2xnlpwFo=
MIME-Version: 1.0
In-Reply-To: <083DF309106F364B939360100EC290F80AC6E5F76D@eu1rdcrdc1wx030.exi.nxp.com>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
	<1281370650-29520-2-git-send-email-wellsk40@gmail.com>
	<AANLkTimAJj38R7KCfHusfsq+EXDd3fbAm=Az_Osqdgbz@mail.gmail.com>
	<083DF309106F364B939360100EC290F80AC6E5F76D@eu1rdcrdc1wx030.exi.nxp.com>
Date: Wed, 11 Aug 2010 09:40:55 +0800
Message-ID: <AANLkTinZBhZ8PRswbqUDyYzmDQ6Ccm96QAO8vpeWn+SD@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver 
	for the LPC32XX SoC
From: Wan ZongShun <mcuos.com@gmail.com>
To: Kevin Wells <kevin.wells@nxp.com>
Cc: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Durgesh Pattamatta <durgesh.pattamatta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Wells <wellsk40@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/11 Kevin Wells <kevin.wells@nxp.com>:
> Hi Zongshun,
>
> Thanks for helping review this.
>
>> Subject: Re: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
>> for the LPC32XX SoC
>>
>> Hi Kevin ,
>>
>> This is really a natty rtc patch:).
>
> From the urban dictionary...
> "natty"
> 1) originating from rastafarian culture. meaning 'good','cool' and
> most importantly, 'elite'.
> 2) A slang for Natural Light beer, a favorite of poor college students
> the world over.
>

Hmm,I means the first, this patch looks very good to me. :)

> I hope it's the first one, but I guess the 2nd isn't that bad if
> you’re a college student o)
> I'll merge both patches into a single patch for v2 and repost in a
> few days.
>
>> > +       /* Disable alarm during update */
>> > +       tmp = rtc_readl(rtc, RTC_CTRL);
>> > +       rtc_writel(rtc, RTC_CTRL, tmp & ~RTC_MATCH0_EN);
>> > +
>> > +       rtc->alarm_enabled = wkalrm->enabled = 1;
>> > +       if (wkalrm->enabled) {
>> > +               rtc_writel(rtc, RTC_MATCH0, alarmsecs);
>> > +               rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS);
>> > +               rtc_writel(rtc, RTC_CTRL, tmp | RTC_MATCH0_EN);
>> > +       }
>>
>> I think this 'wkalrm->enabled ' will always be set '1', so 'if'
>> condition will be alway true?
>
> Thanks for catching this. The '= 1' assignment shouldn't be there.
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
