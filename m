Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1EGNeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 09:34:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41818 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab1EGNeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 09:34:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ji6I4mldrF9AzMbGEzbhj3+fMpbVvhL3RQou3kRQELO61grasug5pqNW9L8QkrdDAJ
         TUO1ENr/488IKtmqcs/ev1S6shc8mJ42vPU/XoctCjkFr2g37XUcodRm7t7xRDjqaFuR
         R0JYOaUGhy2C4s+zHF3GMO9r8qiR0WAlSJlGw=
MIME-Version: 1.0
In-Reply-To: <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<201105061605.31625.arnd@arndb.de>
	<BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
Date: Sat, 7 May 2011 15:34:20 +0200
Message-ID: <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
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

2011/5/6 Rafał Miłecki <zajec5@gmail.com>:
> 2011/5/6 Arnd Bergmann <arnd@arndb.de>:
>>> +const char *bcma_device_name(u16 coreid)
>>> +{
>>> +     switch (coreid) {
>>> +     case BCMA_CORE_OOB_ROUTER:
>>> +             return "OOB Router";
>>> +     case BCMA_CORE_INVALID:
>>> +             return "Invalid";
>>> +     case BCMA_CORE_CHIPCOMMON:
>>> +             return "ChipCommon";
>>> +     case BCMA_CORE_ILINE20:
>>> +             return "ILine 20";
>>
>> It's better to make that a data structure than a switch() statement,
>> both from readability and efficiency aspects.
>
> Well, maybe. We call it only once, at init time. In any case we're
> still waiting for Broadcom to clarify which cores are really used for
> BCMA.

Arnd: did you have a look at defines at all?

Most of the defines have values in range 0x800 → 0x837. Converting
this to array means loosing 0x800 u16 entries. We can not use 0x800
offset, because there are also some defined between 0x000 and 0x800:
#define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
#define BCMA_CORE_INVALID              0x700

Oh and there is still:
#define BCMA_CORE_DEFAULT              0xFFF
we could want to include. Then we would loose additional (0xFFF -
0x837) u16 entries in array.

I'll just leave this huge "case". As I said, it's called only once on
initialization time. For standard PCI cards there are usually 3-5
cores, for embedded systems this number can be bigger, but still is
limited with 16 for 1 bus:
#define BCMA_MAX_NR_CORES              16

-- 
Rafał
