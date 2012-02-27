Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab2B0QXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:23:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46592 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab2B0QXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:23:30 -0500
Message-ID: <4F4BADD2.5020908@zytor.com>
Date: Mon, 27 Feb 2012 08:22:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Schwab <schwab@linux-m68k.org>, Ian Kent <raven@themaw.net>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, Thomas Meyer <thomas@m3y3r.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] autofs4: fix compilation without CONFIG_COMPAT
References: <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com> <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com> <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com> <1329889428.2193.45.camel@perseus.themaw.net> <1329890027.2193.48.camel@perseus.themaw.net> <1329890251.2193.50.camel@perseus.themaw.net> <m2vcmuh8dg.fsf_-_@igel.home> <CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com> <4F4B30D5.6050305@de.ibm.com> <20120227090951.GA2681@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20120227090951.GA2681@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 01:09 AM, Heiko Carstens wrote:
> On Mon, Feb 27, 2012 at 08:29:25AM +0100, Christian Borntraeger wrote:
>> On 26/02/12 02:31, Linus Torvalds wrote:
>>>
>>> +#else
>>> +
>>> +#define is_compat_task() (0)
>>> +
>>
>> Linus,
>>
>> this breaks 32bit builds of s390 (and maybe others), since several platforms already
>> define a is_compat_task.
>
> It breaks only !COMPAT builds on s390, since only we have the is_compat_task()
> function defined for !COMPAT. The reason for that was simply to get rid of a
> couple of ugly  #ifdefs.
> Note, that we still need to include asm/compat.h in some file since we need the
> compat_ptr typedef.
> That might be ugly, but I preferred including that header file so we could get
> rid of the #ifdefs.
> Anyway... the patch below fixes the build issues:
>

This patch would seem to be The Right Thing; the combination of this 
really takes what s390 has done in arch space and globalizes it.

	-hpa

