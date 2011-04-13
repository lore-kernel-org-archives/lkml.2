Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab1DMTuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:50:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35703 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab1DMTuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fUY7L7TfU7x9i6HmbwyUug5WxINkA7TfdaxtohRZrLQCP3ibXZqb795rAGfSuwV4kr
         NggxNs2GpiWHsjEuyzHKyTzasiYN6IBSh8CvEhDSOresYqZ+dRn/Z0nA/f+ogSJyYfju
         yqBDm7hxyuDBw9oPMD4tnLtWBnx0aOtxyeMk0=
MIME-Version: 1.0
In-Reply-To: <op.vtvalzu33ri7v4@arend-laptop>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	<20110412133633.GR15130@legolas.emea.dhcp.ti.com>
	<1302634039.14216.10.camel@dev.znau.edu.ua>
	<BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
	<1302635550.14216.21.camel@dev.znau.edu.ua>
	<BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
	<4DA4AC4B.90409@hauke-m.de>
	<BANLkTiknRYWaDM1ThAxgXcdGqK8jeFaBPA@mail.gmail.com>
	<BANLkTikqKtJuDS17mfFvxzMoXuBtJvCgTA@mail.gmail.com>
	<1302640546.14216.65.camel@dev.znau.edu.ua>
	<BANLkTim8dmTL-BVK3fcWHNBU9Eyz1k_T+Q@mail.gmail.com>
	<op.vtvalzu33ri7v4@arend-laptop>
Date: Wed, 13 Apr 2011 21:50:36 +0200
Message-ID: <BANLkTik6JZ-n3sVjCFK_x1yNRH3_o3_6rg@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: George Kashperko <george@znau.edu.ua>, "balbi@ti.com" <balbi@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/13 Arend van Spriel <arend@broadcom.com>:
> On Tue, 12 Apr 2011 22:44:01 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> 2011/4/12 George Kashperko <george@znau.edu.ua>:
>>>>
>>>> 2011/4/12 Rafał Miłecki <zajec5@gmail.com>:
>>>> That way I see really low (or not at all) relation between out
>>>> (not)Broadcom bus and present AMBA bus.
>>>>
>>> Agree.
>>
>> Ehh, sounds like one more renaming to functions, defines, prefixes.
>>
>> Let's wait for Arend comments, he was the one voting for not-bcm-specific
>> name.
>>
>
> Hi Rafał,
>
> Still think its better to stick with a generic name even if currently you
> only come across this in Broadcom chips right now. I do agree that the term
> 'axi' is implying something else than what this bus driver is providing. The
> name 'axi-dmp' I gave earlier may be more to the point.
>
> I also looked at the amba driver after receiving comments on the brcmaxi
> library module (this is what Hauke Mehrtens referred to) and came to similar
> conclusion as you did. It does however support PM properly so you may want
> to get inspiration in that area. I also noticed a reference to AMBA term APB
> which is a different bus in the AMBA family. AXI was introduced later as
> higher performance bus (in AMBA rev3 if I remember correctly).

I don't focus on PM yet, do not consider it a problem, it just needs some time.

Note for not involved: AMBA is family with few buses/interfaces
possible: AXI, AHB, ASB, APB, ATB [1].

So what are you saying is that drivers/amba/ is for AMBA APB? OK, I
can accept such a explanation and it makes me even more sure we need
another AMBA driver (this time: AMBA AXI).

The left question is: how much of the implemented code is AMBA AXI
specific and how much is Broadcom specific?
1) Does AMBA AXI identify cores by manuf, id, rev and class? Is this
really AMBA AXI specific and a evolution from simple "id" in AMBA APB?
2) Is this standard for AMBA AXI to keep list of available cores in
some specific memory (is this always EPROM like in case of Bcm?)?
3) Does every AMBA AXI device need enabling/disabling/resetting
routine we implemented? Is that really Bcm independent?

This is mostly what I already asked, but didn't get answer. Please,
explain to us what is AMBA AXI specific and what is Broadcom specific.

[1] http://en.wikipedia.org/wiki/Advanced_Microcontroller_Bus_Architecture

-- 
Rafał
