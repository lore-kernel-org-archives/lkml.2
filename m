Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab1HPBtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 21:49:05 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62603 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1HPBtC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 21:49:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MW6OGJnasbbwY+MNRjed5+vk-KJGQ1jsTYfJcMEO6gAQA@mail.gmail.com>
References: <CAKxaRTKtCOR7WHcpaTaVj8wqGoLpO04Vt3_aJ-Qfk=4X6CW0NQ@mail.gmail.com>
	<CACqU3MXNjTTqHs22GNLWS1mrTi5=EQcMYbbStHsuOk9Msd838A@mail.gmail.com>
	<CAKxaRT+hCXu-921RoNw0aiiffZzNGQNgQX0FGfsfdSOP95DzBQ@mail.gmail.com>
	<CACqU3MUSji7z507EhpeWgHkqGfJVVXWWbY4Hi15H8LDz3phjZw@mail.gmail.com>
	<CACqU3MW6OGJnasbbwY+MNRjed5+vk-KJGQ1jsTYfJcMEO6gAQA@mail.gmail.com>
Date: Mon, 15 Aug 2011 21:49:02 -0400
Message-ID: <CACqU3MXha=4Be79gQEtewO8uPDcYeUMUCH5MUAM_CayC4B8RJA@mail.gmail.com>
Subject: Re: Linux 3.0.1 compile problem on different locales..
From: Arnaud Lacombe <lacombar@gmail.com>
To: =?ISO-8859-1?B?U2VyZGFyIEvWWUzc?= <s.koylux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/8/15 Arnaud Lacombe <lacombar@gmail.com>:
> Hi,
>
> 2011/8/15 Arnaud Lacombe <lacombar@gmail.com>:
>> Hi,
>>
>> [Please do not reply only to me, it's considered rude for people on
>> the public mailing list.]
>>
>> 2011/8/15 Serdar KÖYLÜ <s.koylux@gmail.com>:
>>> Dist: MDV 2010.1, but very tweaked manually..
>>>
>>> bash-3.2$ set |grep LC
>>> LC_ADDRESS=tr_TR.UTF-8
>>> LC_COLLATE=tr_TR.UTF-8
>>> LC_CTYPE=tr_TR.UTF-8
>>> LC_IDENTIFICATION=tr_TR.UTF-8
>>> LC_MEASUREMENT=tr_TR.UTF-8
>>> LC_MESSAGES=tr_TR.UTF-8
>>> LC_MONETARY=tr_TR.UTF-8
>>> LC_NAME=tr_TR.UTF-8
>>> LC_NUMERIC=tr_TR.UTF-8
>>> LC_PAPER=tr_TR.UTF-8
>>> LC_SOURCED=1
>>> LC_TELEPHONE=tr_TR.UTF-8
>>> LC_TIME=tr_TR.UTF-8
>>> MAILCHECK=60
>>>
>>>
>> he... obvious:
>>
>> SYNOPSIS
>>       #include <ctype.h>
>>
>>       int toupper(int c);
>>       int tolower(int c);
>>
>> BUGS
>>       The details of what constitutes an uppercase or lowercase
>> letter depend on the current locale.  For example, the default "C"
>> locale does not know about umlauts, so no conversion is done for them.
>>
>>       In some non-English locales, there are lowercase letters with
>> no corresponding uppercase equivalent; the German sharp s is one
>> example.
>>
>>
>> Is Turkish such a corner case where the capital I has no lowercase equivalent ?
>>
> here it is:
>
> http://en.wikipedia.org/wiki/Turkish_dotted_and_dotless_I
>
> So I'd assume that English capital 'I' is treated as a dotless-i,
> however, its lowercase 'i' is a dotted-i. It is unclear (to me) what
> character set's value is meant to be returned by tolower(3). If, it's
> ASCII, I'd assume the Turkish lowercase-dotless-i should able to be
> represented and thus we ends up with the original argument being
> returned.
s/should able to be/should not be able to be/

 - Arnaud
>
>> I guess we should reset the locale to C when generating
>> include/config/ files, it'd be better than re-inventing our special
>> case wheel.
>>
>> Thanks,
>>  - Arnaud
>>
>>> 2011/8/16 Arnaud Lacombe <lacombar@gmail.com>:
>>>> Hi,
>>>>
>>>> [Added linux-kbuild@ to the CC list.]
>>>>
>>>> 2011/8/15 Serdar KÖYLÜ <s.koylux@gmail.com>:
>>>>> FYI.
>>>>>
>>>>> I download latest stable version and try compile it. But process
>>>>> terminated with an error message, such as:
>>>>>
>>>>> error config/modversions.h, file or directory not found (Message is my
>>>>> original language, in Turkish).
>>>>>
>>>>> I check manually this file, found it as:
>>>>>
>>>>> foo/linux-3.0.1/include/config/modversIons.h
>>>>>
>>>>> And all other "i" chars, translated into "I" chars. I run a grep, find this:
>>>>>
>>>>> [root@localhost kconfig]# grep -in tolower *.c
>>>>> confdata.c:730:                 c = tolower(c);
>>>>>
>>>>> I set env. vars such as "LC_CTYPE=C" manually, retry compile kernel,
>>>>> yes, it's compiled now.
>>>>>
>>>>> I don't know best solutions for this problem. A solutions can be write
>>>>> some warnings in related documents. An other solution, make a patch,
>>>>> such as:
>>>>>
>>>>> - confdata.c:730:                 c = tolower(c);
>>>>> +#define TOLOWER(x) ((x) | 0x20)
>>>>> +confdata.c:730:                 c = TOLOWER(c);
>>>>>
>>>>> or makefiles set locale to "C". I don't sure best solution. But this
>>>>> problem occured in turkish and can be occurred other langs.
>>>>>
>>>> What is the Turkish locale you were using originally ?
>>>>
>>>> Thanks,
>>>>  - Arnaud
>>>>
>>>>> Thanks, best regards..
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>
>>>>
>>>
>>
>
