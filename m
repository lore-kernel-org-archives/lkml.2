Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1H3Kch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:32:37 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:58918 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab1H3Kcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:32:36 -0400
Message-ID: <4E5CBC3F.9030006@nod.at>
Date: Tue, 30 Aug 2011 12:32:31 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com
Subject: Re: [PATCH 8/9] um: fix strrchr problems
References: <1314634419-24766-1-git-send-email-richard@nod.at> <1314634419-24766-9-git-send-email-richard@nod.at> <20110829142705.5be82d7c.akpm@linux-foundation.org> <4E5C06DF.60508@nod.at> <20110829221230.GP2203@ZenIV.linux.org.uk> <4E5C0F9F.5000405@nod.at> <20110829221922.GQ2203@ZenIV.linux.org.uk> <4E5C11D5.4020404@nod.at> <20110830002330.GR2203@ZenIV.linux.org.uk> <20110830024853.GS2203@ZenIV.linux.org.uk>
In-Reply-To: <20110830024853.GS2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.08.2011 04:48, schrieb Al Viro:
> On Tue, Aug 30, 2011 at 01:23:31AM +0100, Al Viro wrote:
>> On Tue, Aug 30, 2011 at 12:25:25AM +0200, Richard Weinberger wrote:
>>
>>> I'm building most of the time static.
>>> Using defconfig and
>>> CONFIG_STATIC_LINK=y
>>> it builds fine here (x86_64 and i386)
>>
>> 32bit build works, 64bit one breaks with
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.4.5/../../../../lib/libc.a(strrchr.o): In function `rindex':
>> (.text+0x0): multiple definition of `strrchr'
>>
>> on squeeze/amd64 with stock toolchain and libc (2.11.2-10).  .config, if
>> you care, is as below, but I really suspect that most of that is irrelevant.
>
> As the matter of fact, on the same build system defconfig + STATIC_LINK +
> UML_NET_VDE is enough to reproduce it.
>
> Toolchain:
> 	libc6		2.11.2-10
> 	vde2		2.2.3-3
> 	gcc		4.4.5-8
> 	binutils	2.20.1-16
>
> all from stock stable/amd64.  Note that debian has the original of that
> patch in their user-mode-linux package; see http://bugs.debian.org/494995
> for history.

defconfig + STATIC_LINK +  UML_NET_VDE builds fine for me.

Toolchain (openSUSE 11.4):
glibc: 2.11.3
vde2: 2.3.1
gcc: 4.5.3
binutils: 2.21.1

Is my vde too new?
BTW: Why is only strstr affected, what makes it so special?

Thanks,
//richard
