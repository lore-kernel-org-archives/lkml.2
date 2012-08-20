Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2HTI2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:28:10 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43106 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab2HTI2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <1345450620.2848.12.camel@sauron.fi.intel.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
 <1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
 <20120816115713.726da8f2@pixies.home.jungo.com> <CACQ1gAhFJ6AKYJpc1ZiHm+3Y=APnwUmVL3f0KW=OFMDMWzCVJg@mail.gmail.com>
 <20120816134234.32b468f6@pixies.home.jungo.com> <1345124012.3393.239.camel@sauron.fi.intel.com>
 <20120819100946.646cbb8a@pixies.home.jungo.com> <1345403092.1930.4.camel@kyv>
 <CACQ1gAh7db9Dnqouzv5S=uAfTfavw45dwWSRAozGU4s7y8FA9w@mail.gmail.com> <1345450620.2848.12.camel@sauron.fi.intel.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 20 Aug 2012 10:27:45 +0200
Message-ID: <CACQ1gAgaZegaT5FZpSMJbBWxDSLnXjzHqypdXSq8hwU+aOLZcA@mail.gmail.com>
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space parameter
To: dedekind1@gmail.com
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/20 Artem Bityutskiy <dedekind1@gmail.com>:
> On Mon, 2012-08-20 at 08:55 +0200, Richard Genoud wrote:
>> Hi Artem,
>> 2012/8/19 Artem Bityutskiy <dedekind1@gmail.com>:
>> > Yeah, I wanted to make it 1..256 but forgot, will do now. 0..256 would
>> > need some more work to avoid division by 0.
>> Division by 0 is handled in the get_bad_peb_limit() function, I don't
>> see another dangerous place.
>
>         if (mult_frac(limit, 1024, max_beb_per1024) < device_pebs)
>
> will divide by 0 if max_beb_per1024 is 0.
>
just a few lines before, you've got:
        /*
         * We don't want a division by 0, and having max_beb_per1024 == 0 is ok
         */
        if (!max_beb_per1024)
                return 0;
from commit abae1f1
(or I'm not looking at the right line ?)

>> (and if we want to be coherent with user-space, it should be 0..255,
>> as the range is coded with an u8)
>
> I think it should be uint16_t instead, because we are defining ABI here
> and we should not assume no one will ever nee values higher than 255.
I agree with you, even if 25% of reserved space for bad block seems
insane, we never know...
I'll update that.



-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
