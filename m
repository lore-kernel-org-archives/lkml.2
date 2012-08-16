Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab2HPOcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:32:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52184 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab2HPObr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:31:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120816165027.6520c4f4@pixies.home.jungo.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
 <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
 <20120816115713.726da8f2@pixies.home.jungo.com> <1345123718.3393.235.camel@sauron.fi.intel.com>
 <20120816165027.6520c4f4@pixies.home.jungo.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 16 Aug 2012 16:30:59 +0200
Message-ID: <CACQ1gAhRYSYehym1qA_Oj71KU4fB2+1MEUGi5Wfnb+E=t3jcxA@mail.gmail.com>
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space parameter
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/16 Shmulik Ladkani <shmulik.ladkani@gmail.com>:
> On Thu, 16 Aug 2012 16:28:38 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
>> On Thu, 2012-08-16 at 11:57 +0300, Shmulik Ladkani wrote:
>> >
>> > For the simplest systems (those having one ubi device) that need a
>> > limit
>> > *other* than the default (20 per 1024), they can simply set the config
>> > to their chosen value, as they were used to.
>> >
>> > With you approach, these system MUST pass the limit parameter via the
>> > ioctl / module-parameter.
>>
>> Yeah, when you change the default, you usually need to do an extra step.
>> It does not feel too bad, and I would not keep additional configuration
>> option for a hypothetical user. If someone suffers, we can add an option
>> to change the default. But I'd start without it. So, I think it is OK to
>> remove this.
>
> Yes, but the main drawback I was referring to is those platforms already
> setting MTD_UBI_BEB_RESERVE other than the default, by means of kernel
> configuration.
> (there's one platform known to do so in its defconfig, that's
> sam9_l9260_defconfig, which uses 3% instead of the "standard" 2%).
I found the board:
https://www.olimex.com/dev/sam9-L9260.html
and the nand datasheet:
http://www.rockbox.org/wiki/pub/Main/LyrePrototype/K9xxG08UXM.pdf
page 11, we can see that the max_bad_bebper1024 is 25 (100 for 4096)

> These platforms must now change their usermode code to either pass a
> module parameter during the insmod or change their attach ioctl of
> their application.
>
> We force these systems to change their usermode because we changed ubi's
> default BEB limit to be 20/1024 _hardcoded_ (instead of kernel
> configurable as previously was).
>
> Is this ok?
well, I don't know, Artem, you're the maintainer :)
I made a quick patch on this, if you decide to apply it.

Richard


-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
