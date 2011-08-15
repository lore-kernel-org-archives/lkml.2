Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab1HOW6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 18:58:05 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38611 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab1HOW6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 18:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAKxaRTKtCOR7WHcpaTaVj8wqGoLpO04Vt3_aJ-Qfk=4X6CW0NQ@mail.gmail.com>
References: <CAKxaRTKtCOR7WHcpaTaVj8wqGoLpO04Vt3_aJ-Qfk=4X6CW0NQ@mail.gmail.com>
Date: Mon, 15 Aug 2011 18:58:02 -0400
Message-ID: <CACqU3MXNjTTqHs22GNLWS1mrTi5=EQcMYbbStHsuOk9Msd838A@mail.gmail.com>
Subject: Re: Linux 3.0.1 compile problem on different locales..
From: Arnaud Lacombe <lacombar@gmail.com>
To: =?ISO-8859-1?B?U2VyZGFyIEvWWUzc?= <s.koylux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Added linux-kbuild@ to the CC list.]

2011/8/15 Serdar KÖYLÜ <s.koylux@gmail.com>:
> FYI.
>
> I download latest stable version and try compile it. But process
> terminated with an error message, such as:
>
> error config/modversions.h, file or directory not found (Message is my
> original language, in Turkish).
>
> I check manually this file, found it as:
>
> foo/linux-3.0.1/include/config/modversIons.h
>
> And all other "i" chars, translated into "I" chars. I run a grep, find this:
>
> [root@localhost kconfig]# grep -in tolower *.c
> confdata.c:730:                 c = tolower(c);
>
> I set env. vars such as "LC_CTYPE=C" manually, retry compile kernel,
> yes, it's compiled now.
>
> I don't know best solutions for this problem. A solutions can be write
> some warnings in related documents. An other solution, make a patch,
> such as:
>
> - confdata.c:730:                 c = tolower(c);
> +#define TOLOWER(x) ((x) | 0x20)
> +confdata.c:730:                 c = TOLOWER(c);
>
> or makefiles set locale to "C". I don't sure best solution. But this
> problem occured in turkish and can be occurred other langs.
>
What is the Turkish locale you were using originally ?

Thanks,
 - Arnaud

> Thanks, best regards..
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
