Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab0KGQoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 11:44:17 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41463 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0KGQoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 11:44:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type:content-transfer-encoding;
        b=LhVvVlS9psk+vf6/5SubaxPt1HPKAh6W8XunH9P3C0+yAOPQ1s7DixNKEmZii/saSe
         sKrsNCXKys0uERldi+lO7kb4p5DUYG1lodprL1WTT/vZ8FRmcHSosrHmoU0fnbfuZokp
         5luIun4vQmP1K9QFoH6lCPxbl3J8kFTUCdzCk=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
In-Reply-To: <20101106162426.GA14361@merkur.ravnborg.org>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com> <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com> <87d3qicwxn.fsf@gmail.com> <87aalmcv0p.fsf@gmail.com> <20101106162426.GA14361@merkur.ravnborg.org>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 07 Nov 2010 11:44:13 -0500
Message-ID: <87tyjtjd7m.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Nov 2010 17:24:26 +0100, Sam Ravnborg <sam@ravnborg.org> wrote:
> Took a quick look.
> Does the following patch fix it?
> 
> if m == p then we will stay in the while look looking for a space.
> I did not audit all of the code - there may be other issues..
> 
P.S. Sorry for the noise

Looks like something very odd is happening here. Seems like stat is
giving us the wrong size. As seen below, ls reports the file size to be
5247 whereas st.stat indicates a size substantially larger than
that. Output from make with attached patch applied:

$ ls -l scripts/basic/.fixdep.d
-rw-r--r-- 1 bgamari bgamari 5247 2010-11-07 11:35 scripts/basic/.fixdep.d
$ make V=1
In file included from /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/stdlib.h:903,
                 from scripts/basic/fixdep.c:112:
/usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/stdlib.h:65: warning: no previous prototype for ‘ptsname_r’
file=scripts/basic/.fixdep.d
st.size=2ad5f6cecb36
map=0x2ad5f6fe4000, len=2ad5f6cecb36
m=0x2ad5f6fe4000, end=0x55abedcd0b36
eh?=2ad5f6fe4000
map=0x2ad5f6fe4000, len=2ad5f6cecb36, end=0x55abedcd0b36
m=0x2ad5f6fe4009
A: p=0x2ad5f6fe400a, end=0x55abedcd0b36, str=scripts/basic/fixdep.c \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/types.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/features.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/sys/cdefs.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/wordsize.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/gnu/stubs.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/types.h \
 /usr/lib/gcc/x86_64-linux-gnu/4.4.3/include/stddef.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/typesizes.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/time.h \

[SNIP]

B: p=0x2ad5f6fe53e1, end=0x55abedcd0b36
C: p=0x2ad5f6fe53e1, s=/usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/asm/sockios.h
m=0x2ad5f6fe53e2
m=0x2ad5f6fe53e3
m=0x2ad5f6fe53e4
A: p=0x2ad5f6fe53e5, end=0x55abedcd0b36, str=/usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/socket2.h \
 /usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/in.h

B: p=0x2ad5f6fe5432, end=0x55abedcd0b36
C: p=0x2ad5f6fe5432, s=/usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/socket2.h
m=0x2ad5f6fe5433
m=0x2ad5f6fe5434
m=0x2ad5f6fe5435
A: p=0x2ad5f6fe5436, end=0x55abedcd0b36, str=/usr/local/angstrom/arm/arm-angstrom-linux-gnueabi/usr/include/bits/in.h

/bin/sh: line 1:  8456 Bus error               scripts/basic/fixdep scripts/basic/.fixdep.d scripts/basic/fixdep 'gcc -Wp,-MD,scripts/basic/.fixdep.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer     -o scripts/basic/fixdep scripts/basic/fixdep.c  ' > scripts/basic/.fixdep.tmp
make[2]: *** [scripts/basic/fixdep] Error 135
make[1]: *** [scripts_basic] Error 2
make: *** No rule to make target `include/config/auto.conf', needed by `include/config/kernel.release'.  Stop.
