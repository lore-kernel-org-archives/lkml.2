Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1IODMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 23:12:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59315 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1IODMG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 23:12:06 -0400
MIME-Version: 1.0
In-Reply-To: <web-606798161@zbackend1.aha.ru>
References: <web-606439650@zbackend1.aha.ru> <CA+55aFwyC7s=YK10Wkpr+GzdukXp-JUtf_=MgWcrhBOtTg4eTg@mail.gmail.com>
 <web-606798161@zbackend1.aha.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Sep 2011 20:11:44 -0700
X-Google-Sender-Auth: luo8Wxcry1d7SCnG5YnJ3ZbEWis
Message-ID: <CA+55aFwBuySWa2VErrfud_SFqyfT5ib+Qfq9gWBaBz=cQ6VcHg@mail.gmail.com>
Subject: Re: 3.1-rc6 boot problem reason searching
To: werner <w.landgraf@ru.ru>, Andy Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/14 werner <w.landgraf@ru.ru>:
> With M586 it also boots.
>
> Enclosed is the dmesg , if of any importance š (ignore that the kernel is
> named -i486, this is only because I don't want to rename everything, hoping
> that soon M486 returns to work).
>
> Below is also the diff which config's are changed implicitely on changing
> from M486 to M586 .

Ok. That looks *very* much like the same old "x86-32: Fix boot with
CONFIG_X86_INVD_BUG" problem that was supposedly fixed by commit
b4ca46e4e82a, but maybe something else in your config means that
there's yet another case of the same bug that Arnaud Lacombe just
hadn't seen.

Andy: any ideas?

> Thus, the problem is between M486 and M586 , šcompiled with 486 it don't
> boot, but compiled for 586 it boots.

Andy, the problem looks like another oops in
alternative_instructions(). But this one happens with -rc6 too, so
there's something else wrong - commit b4ca46e4e82a is already there.

Werner, can you send Andy your full .config?

                          Linus
