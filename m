Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab1EHPaG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:30:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47770 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1EHPaB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rfRCVO34wSbVaYqGynvD6FBVvkp1sMrZRdJKEnULctMMTPuGvSzzDFfF+ickhRM35a
         qzqj869PEFbiBgryp6nyJ7D0au6UXNyYmA+NTir+Y0+MZumQDAbTxMQKoRnyBHYAa6KC
         Bt5jEUWSIJW74P5yBZ7jQ3/e53elizmmEoFXM=
MIME-Version: 1.0
In-Reply-To: <201105081706.12449.arnd@arndb.de>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	<BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	<201105081706.12449.arnd@arndb.de>
Date: Sun, 8 May 2011 17:25:55 +0200
Message-ID: <BANLkTinujj_E4xPvbXB_AQM-d9BqHRts8Q@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/8 Arnd Bergmann <arnd@arndb.de>:
> On Saturday 07 May 2011, Rafał Miłecki wrote:
>> > Well, maybe. We call it only once, at init time. In any case we're
>> > still waiting for Broadcom to clarify which cores are really used for
>> > BCMA.
>>
>> Arnd: did you have a look at defines at all?
>>
>> Most of the defines have values in range 0x800 → 0x837. Converting
>> this to array means loosing 0x800 u16 entries. We can not use 0x800
>> offset, because there are also some defined between 0x000 and 0x800:
>> #define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
>> #define BCMA_CORE_INVALID              0x700
>
> I did not mean using the enum value as index, just make an array of
> simple structs:
>
> struct bcma_device_name {
>        unsigned int id;
>        const char *name;
> };
>
> struct bcma_device_name bcma_device_names = {
>        { BCMA_CORE_OOB_ROUTER, "Out of band router" },
>        { BCMA_CORE_INVALID,    "Invalid" },
>        ...
> };

Arnd, right now I'm loosing a lot of time (I could spent on improving
bcma or b43) on posting new version of this huge patch with single
changes. Changes that can easily be introduced later without breaking
driver, ABI, etc.

I'll be glad to try your solution later, when we get this patch
merged. I'll be much easier to play with such a differences then.
Thanks for sharing this idea.

Right now I want to focus on some bugs in driver that don't allow it
being merged.

-- 
Rafał
