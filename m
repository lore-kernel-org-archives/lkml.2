Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0HJWmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:42:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58050 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab0HJWmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:in-reply-to:references:user-agent:x-face
         :face:x-url:x-pgp-fp:x-pgp:date:message-id:mime-version:content-type
         :content-transfer-encoding;
        b=UUAOm2azIZs/UaXarETO/0oov6+EvXDawXMPphxfstnxDOuwfiOc0I0w8W5rIMjCTn
         Xs3mjIe12hLRUXy46eaDyol5SZ2iQmRCATHf04Pk9jX4hGyxhjjWw2PV+XhvUjt2EKaV
         XTepE/GIy9oKUE/ehitEsdtpqPzMmxDoLre8Q=
From: Michal Nazarewicz <mina86@mina86.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
        linux-kernel@vger.kernel.org, "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv2 1/3] lib: vsprintf: optimised put_dec_trunc() and  put_dec_full()
In-Reply-To: <AANLkTinQNvdKXGmeBS0UbBuur1LQJb=JUf1WyrYN7Yez@mail.gmail.com>
	(Denys Vlasenko's message of "Tue, 10 Aug 2010 18:08:16 +0200")
References: <6f90103dea29739de0f4f0ede3f3da68afe84343.1281295424.git.mina86@mina86.com>
	<201008100517.48231.vda.linux@googlemail.com>
	<op.vg7owkd67p4s8u@pikus>
	<AANLkTinQNvdKXGmeBS0UbBuur1LQJb=JUf1WyrYN7Yez@mail.gmail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Wed, 11 Aug 2010 00:42:43 +0200
Message-ID: <87eie6w0m4.fsf@erwin.mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:

> 2010/8/10 Michał Nazarewicz <m.nazarewicz@samsung.com>:
>>> On Sunday 08 August 2010 21:29, Michal Nazarewicz wrote:
>>>>
>>>> +       /*
>>>> +        * '(x * 0xcccd) >> 19' is an approximation of 'x / 10' that
>>>> +        * gives correct results for all x < 81920.  However, because
>>>> +        * intermediate result can be at most 32-bit we limit x to be
>>>> +        * 16-bit.
>>>> +        *
>>>> +        * Because of those, we check if we are dealing with a "big"
>>>> +        * number and if so, we make it smaller remembering to add to
>>>> +        * the most significant digit.
>>>> +        */
>>>> +       if (q >= 50000) {
>>>> +               a  = '5';
>>>> +               q -= 50000;
>>>
>>> ...
>>>>
>>>> +       /*
>>>> +        * We need to check if q is < 65536 so we might as well check
>>
>> On Tue, 10 Aug 2010 05:17:48 +0200, Denys Vlasenko
>> <vda.linux@googlemail.com> wrote:
>>>
>>> You meant "need to check if q is < 81920"?
>>
>> No.  81920 is a 17 bit number and when we multiply it by 0xcccd we lose
>> the most significant bit.
>>  Therefore we cannot use the '(x * 0xcccd) >>
>> 19' approximation for numbers which are higher then 65535.
>
> No. All x up to (exclusive) 81920 can be multiplied by 0xcccd
> and result still fits into 32 bits. Proof:
>
> # printf "%x\n" $((81919 * 0xcccd))
> ffff7333

Turns out something else was a problem ((x * 13) >> 7 works for x <
69).  I'll update comments in the next version.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
