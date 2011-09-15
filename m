Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934042Ab1IOPWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:22:00 -0400
Received: from mail-gx0-f170.google.com ([209.85.161.170]:35963 "EHLO
	mail-gx0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933990Ab1IOPV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:21:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7F2Pu0K1Oe3oLe5Pef2kaGE8vdO2qgfc0KEt8TJdUaOWg@mail.gmail.com>
References: <web-606439650@zbackend1.aha.ru> <CA+55aFwyC7s=YK10Wkpr+GzdukXp-JUtf_=MgWcrhBOtTg4eTg@mail.gmail.com>
 <web-606798161@zbackend1.aha.ru> <CA+55aFwBuySWa2VErrfud_SFqyfT5ib+Qfq9gWBaBz=cQ6VcHg@mail.gmail.com>
 <web-606831561@zbackend1.aha.ru> <CAObL_7F2Pu0K1Oe3oLe5Pef2kaGE8vdO2qgfc0KEt8TJdUaOWg@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 15 Sep 2011 08:21:37 -0700
X-Google-Sender-Auth: BeLDhBGLjSauGEpnMTIFuLHMo_E
Message-ID: <CAObL_7E0iyinOyXU=uQHyQN+TBNmVVB89r_hQUb8LTqJ2ix_5A@mail.gmail.com>
Subject: Re: 3.1-rc6 boot problem reason searching
To: werner <w.landgraf@ru.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 7:41 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> 2011/9/14 werner <w.landgraf@ru.ru>:
>> The config is below. šThat's the M486 config which don't boor. šThe M586
>> config which boots has the diff given in my last mail, and which for make
>> the comparison more easy I give below again. š As said, all 3.0-rcX and up
>> to 3.0.4 boot with 486 too, the problem started with 3.1-rc1 . Perhaps the
>> šmessages before the computer sticked (using the M486 config below) which I
>> copied manually from the screen, posted in the treat 3.1-rc5 boot problem š,
>> may be helpful to find out what exactly causes the sticking.
>> wl
>
> Gack. šI obviously did a terrible job grepping for this stuff when I
> wrote the original patch. šThe problem is probably in static_cpu_has.
> I'll send a patch in a little bit.

-ETOOEARLYINTHEMORNING.  static_cpu_has looks correct.

werner, your kernel survives:

for i in `find -name \*.o`; do objdump -j .altinstructions -r "$i"
2>/dev/null |grep R_ |grep -v R_386_PC32\ ; done

Can you try the same command in your build directory?

In the mean time, I'll see if I can reproduce the crash in qemu by
playing with -cpu.

--Andy
