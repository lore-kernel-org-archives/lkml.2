Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1IEAEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 20:04:52 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39373 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab1IEAEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 20:04:49 -0400
MIME-Version: 1.0
In-Reply-To: <87hb4tvoth.fsf@devron.myhome.or.jp>
References: <CADDb1s1A38RyioiehzbRCgjFQT-MhfoD7cutxkn+h_cvUcZpfg@mail.gmail.com>
	<CAKYAXd8gLN4C54Ey5uuK+_FY0U+tBf4aHntX=B+d0eNgY=rNsA@mail.gmail.com>
	<87hb4tvoth.fsf@devron.myhome.or.jp>
Date: Mon, 5 Sep 2011 09:04:47 +0900
Message-ID: <CAKYAXd-XTxA=BNpdYNJOAqN0R7EBMqJj6DgTseCww5prbSvDcg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_vfat_filesystem=3A_Why_utf8=3D1_when_iocharset=3D=E2=80=9Dut?=
	=?UTF-8?Q?f8=E2=80=9D_was_already_there=3F?=
From: NamJae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/3 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> NamJae Jeon <linkinjeon@gmail.com> writes:
>
>> 2011/9/2 Amit Sahrawat <amit.sahrawat83@gmail.com>:
>>> From my opinion both should support the same functionality as the
>>> motive behind this seems to introduce the complete support for utf8.
>>> But, I am surprised to see the behavior changes in the ‘2’ options.
>>> 1)      When using iocharset=”utf8” it makes vfat case sensitive, while
>>> this is not the case with using utf8=1
>>> 2)      Surrogate pair don’t work when using iocharset=”utf8”, because that
>>> traverses a path like this:
>>> xlate_to_uni()-->nls->char2uni()-->char2uni()-->utf8_to_utf32()
>>> After this it returns EINVAL because Surrogate pair correct code is
>>> greater than 0xFFFF (MAX_WCHAR_T – limit which is put)
>>> But this is not the case with utf8=1
>>> There are other places also where I can see usage different due to
>>> usage of char2uni()
>>>
>>> Can someone provide any help on this? Why do we have separate options
>>> for using utf8 and if utf8=1 smoothly supports proper working then why
>>> not discard iocharset=”utf8” ? and if this is not the case
>>> why was utf8=1 introduced?
>>>
>>> Please provide any guidance in this.
>>>
>>> Thanks & Regards,
>>> Amit Sahrawat
>>>
>>
>> I also am wondering this issue for long time.
>> May be, Ogawa will know well.
>
> History is simple. There already was the utf8 option before nls utf8
> module was introduced. And utf8 was introduced for other of FAT.
>
> Well, it doesn't provide case letter conversion table for some
> reasons. But, FAT requires conversion table. For utf8 option, it
> emulates the case conversion by using tables in iocharset= or nls= nls
> module.
>
> NLS infrastructure has several limitation, and to support encoding
> conversion and case letter more fully, it would be better to introduce
> new infrastructure. But it would need not small change.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>

Hi. Ogawa.

If the user to use FAT first time, they are confused about this
option, or they may use only iocharset without knowing the utf8
option(there is case sensitive issue). If nls_utf8 is improved such as
adding upper/lower case translation table, supporting surrogate pair
etc.., I want to know whether you can integate only iocharset=utf8
with removing utf8 option.
If done like above my suggetion, user can use only
option(iocharset=utf8) without confusing.

Thanks.
