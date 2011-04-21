Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1DULgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:36:50 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:44779 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1DULgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:36:49 -0400
Date: Thu, 21 Apr 2011 13:36:47 +0200
From: Andreas Mohr <andi@lisas.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andreas Mohr <andi@lisas.de>, Sam Ravnborg <sam@ravnborg.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: [PATCH] eradicate bashisms in scripts/patch-kernel
Message-ID: <20110421113647.GA18572@rhlx01.hs-esslingen.de>
References: <20071102020118.GA13852@gondor.apana.org.au>
 <20071102200935.GA14153@rhlx01.hs-esslingen.de>
 <20071102131707.6023a5b7.rdunlap@xenotime.net>
 <20071105195827.GA24117@rhlx01.hs-esslingen.de>
 <20071114144627.8628f2dd.rdunlap@xenotime.net>
 <20071117163327.GA4296@rhlx01.hs-esslingen.de>
 <20071117172816.GC7213@uranus.ravnborg.org>
 <20071117205125.GA26425@rhlx01.hs-esslingen.de>
 <20110403185828.GA4561@rhlx01.hs-esslingen.de>
 <20110403124004.293c90c5.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110403124004.293c90c5.rdunlap@xenotime.net>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry for the delay. Didn't have a suitable environment at that time,
then it got buried...

On Sun, Apr 03, 2011 at 12:40:04PM -0700, Randy Dunlap wrote:
> On Sun, 3 Apr 2011 20:58:28 +0200 Andreas Mohr wrote:
> > # linux-2.6.38.patch-kernel_test/scripts/patch-kernel linux-2.6.38.patch-kernel_test patch-2.6
> > Current kernel version is 2.6.38 ( Flesh-Eating Bats with Fangs)
> > ===>  linux-2.6.38.patch-kernel_test/scripts/patch-kernel: line 253: [: =: unary operator expected  <===
> > cannot find patch file: patch-2.6.39
> 
> Hi,
> 
> Are you trying to update a 2.6.38 kernel directory to 2.6.39?
> I'm a little confused since the command line does not say anything about 2.6.39.

Well, that virtual setup was just for the sake of having a problem test case.
I should have described it in more detail.
It simply tries to increment to the next patch version, which in case
of 2.6.38 input would be 2.6.39 (which... obviously isn't available yet).

> > Since my last patch (the parent mail) happened to modify the very same line,
> 
> Parent email from 2007???  wow.  :)

Yup - why not simply reply on the original patch?
For suitable tracking, I'd rather have one reference too many than......

Perhaps I should have replied on some ~1995 mail? ;-P

> Why doesn't the debug/trace info show the value of STOPFULLVERSION?
> Is it empty?

Augmented version:

do
    CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
    EXTRAVER=
    echo "STOPFULLVERSION is $STOPFULLVERSION"
    if [ $STOPFULLVERSION = $CURRENTFULLVERSION ]; then
        echo "Stopping at $CURRENTFULLVERSION base as requested."
        break
    fi


# linux-2.6.30/scripts/patch-kernel linux-2.6.30 patch-2.6
Current kernel version is 2.6.30 ( Man-Eating Seals of Antiquity)
STOPFULLVERSION is 
[: 276: =: unexpected operator
Applying patch-2.6.31 (bzip2)... done.
STOPFULLVERSION is 
[: 276: =: unexpected operator
Applying patch-2.6.32 (bzip2)... done.
STOPFULLVERSION is 
[: 276: =: unexpected operator
Applying patch-2.6.33 (bzip2)... done.
STOPFULLVERSION is 
[: 276: =: unexpected operator
Applying patch-2.6.34 (bzip2)... done.
STOPFULLVERSION is 
[: 276: =: unexpected operator
cannot find patch file: patch-2.6.35

--> seems so.

> Michal is the new kbuild maintainer, so he could queue it, or I can.

He's been queueing it immediately, thus everything went fine (--> thanks!).

Thanks,

Andreas Mohr
