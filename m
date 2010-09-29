Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0I2O3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:29:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48236 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750996Ab0I2O3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:29:42 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19HDfpgQ4RHhdqAmoA/5/kQMeYdE6bgRnvMjTuykn
	YxOMhSOnDtW9eK
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: dma-mapping commit breaks UML
Date: Wed, 29 Sep 2010 16:29:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6; KDE/4.4.5; i686; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201009291155.30873.toralf.foerster@gmx.de> <20100929221620K.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100929221620K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009291629.39077.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FUJITA Tomonori wrote at 15:20:38
> On Wed, 29 Sep 2010 11:55:30 +0200
> 
> Toralf **UNKNOWN CHARSET** <toralf.foerster@gmx.de> wrote:
> > The
> > 
> > 4565f0170dfc849b3629c27d769db800467baa62 is the first bad commit
> > commit 4565f0170dfc849b3629c27d769db800467baa62
> > Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date:   Tue Aug 10 18:03:22 2010 -0700
> > 
> >     dma-mapping: unify dma_get_cache_alignment implementations
> 
> I think that the commit f3c072ad727617f00bffae17dba8cd895f5b7bdb
> already fixed this breakage. You still have the issue with the latest
> git?

Argh,

I use a script for git-bisect to catch this compile error in the current git kernel v2.6.36-rc6-20-g8189b14 :

...
  CC      arch/um/kernel/trap.o
arch/um/drivers/hostaudio_kern.c: In function ‘hostaudio_open’:
arch/um/drivers/hostaudio_kern.c:204: error: ‘__param_dsp’ undeclared (first use in this function)
arch/um/drivers/hostaudio_kern.c:204: error: (Each undeclared identifier is reported only once
arch/um/drivers/hostaudio_kern.c:204: error: for each function it appears in.)
arch/um/drivers/hostaudio_kern.c: In function ‘hostmixer_open_mixdev’:
arch/um/drivers/hostaudio_kern.c:265: error: ‘__param_mixer’ undeclared (first use in this function)
arch/um/drivers/hostaudio_kern.c:272: error: ‘__param_dsp’ undeclared (first use in this function)
make[1]: *** [arch/um/drivers/hostaudio_kern.o] Error 1
make: *** [arch/um/drivers] Error 2
make: *** Waiting for unfinished jobs....
...

but catched another compile error -  how can I now automatically git-bisect for
that wrong commit w/o heavy scripting ? - Or simply asking who to blame wrt this compile error ?

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

