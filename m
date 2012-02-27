Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2B0HaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:30:08 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:54622 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2B0HaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:30:03 -0500
Message-ID: <4F4B30D5.6050305@de.ibm.com>
Date: Mon, 27 Feb 2012 08:29:25 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andreas Schwab <schwab@linux-m68k.org>, Ian Kent <raven@themaw.net>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] autofs4: fix compilation without CONFIG_COMPAT
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com> <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com> <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com> <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com> <1329889428.2193.45.camel@perseus.themaw.net> <1329890027.2193.48.camel@perseus.themaw.net> <1329890251.2193.50.camel@perseus.themaw.net> <m2vcmuh8dg.fsf_-_@igel.home> <CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com>
In-Reply-To: <CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12022707-5024-0000-0000-000001CEE881
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/12 02:31, Linus Torvalds wrote:
>  
> +#else
> +
> +#define is_compat_task() (0)
> +

Linus,

this breaks 32bit builds of s390 (and maybe others), since several platforms already
define a is_compat_task. This macro then destroys the definition of the function
making

static inline int is_compat_task(void)
{
        return 0;
}


into

static inline int 0
{
        return 0;
}

e.g.

In file included from arch/s390/mm/fault.c:39:0:
/home/autobuild/BUILD/linux-3.3.0-rc5.00060.g203738e.49.x.20120227/arch/s390/include/asm/compat.h:177:38: error: macro "is_compat_task" passed 1 arguments, but takes just 0
/home/autobuild/BUILD/linux-3.3.0-rc5.00060.g203738e.49.x.20120227/arch/s390/include/asm/compat.h:178:1: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
  CC      arch/s390/kernel/time.o




Christian

