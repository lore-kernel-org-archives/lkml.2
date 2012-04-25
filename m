Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab2DYBTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 21:19:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13703 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab2DYBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 21:19:17 -0400
X-AuditID: cbfee61b-b7c1cae000004793-a8-4f9751131bbb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joe Perches'" <joe@perches.com>
Cc: "'Ryan Mallon'" <rmallon@gmail.com>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Julia Lawall'" <julia.lawall@lip6.fr>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1334777828-3557-1-git-send-email-Julia.Lawall@lip6.fr>
 <4F8F5938.2000207@gmail.com> <000401cd1dd2$5f8ee3b0$1eacab10$%han@samsung.com>
 <alpine.DEB.2.02.1204190713200.1954@localhost6.localdomain6>
 <1335271586.25429.19.camel@joe2Laptop>
In-reply-to: <1335271586.25429.19.camel@joe2Laptop>
Subject: RE: [PATCH] drivers/video/ep93xx-fb.c: clean up error-handling code
Date: Wed, 25 Apr 2012 10:19:15 +0900
Message-id: <000e01cd2281$6ddd2ef0$49978cd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0iRY5a0dUgh3PUT9uFqUm7uymZfgAO0udw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Apr 2012, Joe Perches wrote:
> -----Original Message-----
> On Thu, 2012-04-19 at 07:14 +0200, Julia Lawall wrote:
> > I don't know thw impact of the ./.  I use the options
> >
> > --nokeywords --nogit-fallback --subsystem --norolestats -f
> >
> > julia
> >
> > On Thu, 19 Apr 2012, Jingoo Han wrote:
> >
> > >> -----Original Message-----
> > >> From: Ryan Mallon
> []
> > >> Oddly, scripts/get_maintainer.pl on this file doesn't return me, even
> > >> though, according to git blame, I am the author of 90% of the commits.
> > >> Should I have an entry in the MAINTAINERS file, or is
> > >> scripts/get_maintainer.pl not working properly?
> > >
> > > There are optional differences in using scripts/get_maintainer.pl.
> > > If you use './' ahead of file path, you will see your name.
> > >
> > > Without './' ahead of 'drivers/video/ep93xx-fb.c':
> > > ./scripts/get_maintainer.pl --file drivers/video/ep93xx-fb.c
> > > Florian Tobias Schandinat <FlorianSchandinat@gmx.de> (maintainer:FRAMEBUFFER LAYER)
> > > linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
> > > linux-kernel@vger.kernel.org (open list)
> > >
> > > With './' ahead of 'drivers/video/ep93xx-fb.c':
> > > ./scripts/get_maintainer.pl --file ./drivers/video/ep93xx-fb.c
> > > Ryan Mallon <rmallon@gmail.com> (commit_signer:2/3=67%)
> > > Paul Gortmaker <paul.gortmaker@windriver.com> (commit_signer:1/3=33%)
> > > H Hartley Sweeten <hsweeten@visionengravers.com> (commit_signer:1/3=33%)
> > > Jesper Juhl <jj@chaosbits.net> (commit_signer:1/3=33%)
> > > Jiri Kosina <jkosina@suse.cz> (commit_signer:1/3=33%)
> > > linux-kernel@vger.kernel.org (open list)
> 
> Prefixing "./" to the file path bypasses the normal
> get_maintainers pattern check for file maintainership.
> 
> Florian Schandinat and linux-fbdev are not returned
> in the second lookup above.
> 
> One of the patterns for FRAMEBUFFER is
> F:	drivers/video/
> which is a direct match for is ep93xx-fb.c file,
> so --git is not used by default.
> 
> Adding --git may be appropriate and it also returns
> Ryan's name in this case.
> 
> $ ./scripts/get_maintainer.pl -f drivers/video/ep93xx-fb.c
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> (maintainer:FRAMEBUFFER LAYER)
> linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
> linux-kernel@vger.kernel.org (open list)
> 
> $ ./scripts/get_maintainer.pl --git -f drivers/video/ep93xx-fb.c
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> (maintainer:FRAMEBUFFER LAYER)
> Ryan Mallon <rmallon@gmail.com> (commit_signer:2/3=67%)
> Paul Gortmaker <paul.gortmaker@windriver.com> (commit_signer:1/3=33%)
> H Hartley Sweeten <hsweeten@visionengravers.com> (commit_signer:1/3=33%)
> Jesper Juhl <jj@chaosbits.net> (commit_signer:1/3=33%)
> Jiri Kosina <jkosina@suse.cz> (commit_signer:1/3=33%)
> linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
> linux-kernel@vger.kernel.org (open list)
> 
> Nominally, as framebuffer maintainer, Florian
> should also have "signed-off" on these commits,
> but many subsystems don't actually have a
> single path or person for patches and commits.
> 
> This file came into the tree via Andrew Morton.
> 
> Another way to investigate who actually does
> work on an individual file is to use the
> get_maintainer.pl option "--interactive".

Thank you for your reply.
It is very helpful.

Best regards,
Jingoo Han

> 
> That can give you an output like:
> 
> *  # email/list and role:stats                                        auth sign
> *  1 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>      maintainer:FRAMEBUFFER LAYER
> *  2 Ryan Mallon <rmallon@gmail.com>                                     4    4
>      commit_signer:2/3=67%,authored lines:645/650=99%,commits:4/8=50%
> *  3 Paul Gortmaker <paul.gortmaker@windriver.com>                       1    1
>      commit_signer:1/3=33%,commits:1/8=12%
> *  4 H Hartley Sweeten <hsweeten@visionengravers.com>                    0    2
>      commit_signer:1/3=33%,commits:2/8=25%
> *  5 Jesper Juhl <jj@chaosbits.net>                                      0    1
>      commit_signer:1/3=33%
> *  6 Jiri Kosina <jkosina@suse.cz>                                       0    1
>      commit_signer:1/3=33%
> *  7 Andrew Morton <akpm@linux-foundation.org>                           0    2
>      commits:2/8=25%
> *  8 Russell King <rmk+kernel@arm.linux.org.uk>                          0    1
>      commits:1/8=12%
> *  9 linux-fbdev@vger.kernel.org
>      open list:FRAMEBUFFER LAYER
> * 10 linux-kernel@vger.kernel.org
>      open list
> 
> About maintainership for individual files:
> 
> If anyone thinks they are the maintainer for
> a particular file, generally they should submit
> a patch to MAINTAINERS adding a section with
> their name, maintainership level and an
> appropriate file pattern.

