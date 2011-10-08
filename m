Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1JHLOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 07:14:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64311 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1JHLOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 07:14:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Paulo Marques <pmarques@grupopie.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: Question about "Inconsistent kallsyms data"
Date: Sat, 08 Oct 2011 13:14:06 +0200
Message-ID: <8197014.WsynFjtK5s@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <CAMPhdO80ua0WphKnx3nyBLN7LsUDnDKPX1QbzWEjjfO5t3Uz5Q@mail.gmail.com>
References: <02ae01cc4d91$aed71670$0c854350$%kim@samsung.com> <4E382602.6050308@grupopie.com> <CAMPhdO80ua0WphKnx3nyBLN7LsUDnDKPX1QbzWEjjfO5t3Uz5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XCT9Yr6Ls9K6voE5pbY/fGIQ8fg4bXtyZG8Gz+rHy7A
 7e5iZjABSIfo7yMbVgO58024DVTgKMDVroJ4p1ZmEGf4krfdEt
 QAoYlH9TpbUlddmVz6McrMd4lGTXmYn7X8wagWQz7bRXCKwKh5
 k0HwJgtKUtwua6gOHzqBomN/yee+rTf1EBVTlWatF3/FtvoARh
 f+cHnDkrWDfk3RnqMo5pAuL/bIC5BxweFNZlqzINEWl/tpm45k
 f7uHocLJo4AlhoYLa5d9qNbth/soSL1rCnjuNZro3Xvr9+XO4C
 2kN6iGlGjqQeNQaIrGLl0F/zlILB8JhnedWF9vUIa9jjwJQ5kD
 Um3RLSUcshiyduhdFU94=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 October 2011 18:17:49 Eric Miao wrote:
> >
> > To check inconsistencies, the Makefile compares ".tmp_System.map" and
> > "System.map" for differences.
> >
> > On a normal build they should be identical, but if this fails with
> > "Inconsistent kallsyms data" you could try comparing the two files to
> > check which symbols are causing trouble.
> 
> I met this issue today as well. Didn't have a chance to compare the
> files, as I did a 'rm -fr ../build' and reconfigured/re-built everything,
> and 'make O=../build clean' didn't work for me.

I can easily reproduce it here, but it's extremely hard to nail
down what is actually going on.

For all I know, this depends on the specific configuration, source
version and gcc version. If you change any of these in any meaningful
way, the problem can go away or reappear. In one case, I've been
able to get to the point where inserting a single 'nop' instruction
in one (any) source file triggered the problem. This happens to be
the point when one of the linker sections grows beyond some power-of-two
boundary.

If anyone wants to reproduce it, I can recommend taking a fast machine
and the for-next+randconfig branch of git://git.linaro.org/people/arnd/arm-soc.git
There is a script called randconfig.sh in it. Remove the KALLSYMS_EXTRA_PASS=1
line from it and run it for some time. After a few hours you will get
multiple configurations for your compiler that show the problem.

I've had one case where even with KALLSYMS_EXTRA_PASS=1 I was still getting
inconsistent kallsyms data. Manually changing the Makefile to do a fourth
run fixed it.

	Arnd
