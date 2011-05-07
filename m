Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1EGRUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 13:20:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48072 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab1EGRUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 13:20:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=COKhZDMcaDXDW1VJX2KFXb69IVj52kK8sQob6bI4G16SkD8E4Pysk0hfgOh42fIk0B
         S2sOIK8811bTNe66d1hmEQgKzZKTTHSY/fOOOUMYz8Q/58g4mder1Ml69ouYnwzca4Pn
         ECr/HbhLvZheJ7iQgXB+W4rzKRvgKC0WkPyYc=
MIME-Version: 1.0
In-Reply-To: <4DC57B81.6030705@broadcom.com>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<201105061605.31625.arnd@arndb.de>
	<BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	<BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	<1304776555.16344.2.camel@maggie>
	<4DC57383.3050903@broadcom.com>
	<BANLkTi=GJs=04H=HpCDy_o1JnhY4+aPgxA@mail.gmail.com>
	<4DC57B81.6030705@broadcom.com>
Date: Sat, 7 May 2011 19:20:18 +0200
Message-ID: <BANLkTikEGGSsm1ZFcT4Y9AOijSRAZfa7oQ@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>, Arnd Bergmann <arnd@arndb.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/7 Arend van Spriel <arend@broadcom.com>:
> On 05/07/2011 06:49 PM, Rafał Miłecki wrote:
>>
>> 2011/5/7 Arend van Spriel<arend@broadcom.com>:
>>>
>>> On 05/07/2011 03:55 PM, Michael Büsch wrote:
>>>>>
>>>>> Arnd: did you have a look at defines at all?
>>>>>
>>>>> Most of the defines have values in range 0x800 → 0x837. Converting
>>>>> this to array means loosing 0x800 u16 entries. We can not use 0x800
>>>>> offset, because there are also some defined between 0x000 and 0x800:
>>>>> #define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
>>>>> #define BCMA_CORE_INVALID              0x700
>>>
>>> Please be aware that the core identifier itself is not unique (in the
>>> current list they are). In the scan the BCMA_CORE_OOB_ROUTER will always
>>> show BCMA_MANUF_ARM (did not look up the proper manufacturer define but
>>> you
>>> get the idea, i hope).
>>
>> Unfortunately, I don't. Could you explain this? How core identified
>> can be not unique? Can 0x800 mean ChipCommon but also SuperPCIeX?
>
> Yes, if ChipCommon is Broadcom core and SuperPCIeX is ARM core (or some
> other). The core identifiers are chosen by a chip manufacturer (eg. Broadcom
> ;-) ). They are not unique by itself so that is why the bcma_device_id
> consists of manufacturer, id, rev, and class. Providing a device table with
> ANY_MANUF would be a bad idea.

OK, we use MANUF in identification... so where is the problem? ;)

My testing patch for b43 "subscribes" for Broadcom's cores only:
static const struct bcma_device_id b43_bcma_tbl[] = {
	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x17, BCMA_ANY_CLASS),
	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211, 0x18, BCMA_ANY_CLASS),
	BCMA_CORETABLE_END
};

-- 
Rafał
