Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0GMUux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:50:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62877 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab0GMUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=r6z4M+wCChTpr9r6lQ/fOGNB2iBnkejPYG60p9Blw2ULmFy7irmXuSRKqk8ihmQLQc
         7ZONmVRwz9fEv/w+N571ItCoadwTtz66zmVvt/C/s3UuobA98KzLrF62EhEXmv7oUprL
         z8mNAiprgWn998GoRnrziOHXoAdZ6B1/zMma4=
MIME-Version: 1.0
Date: Tue, 13 Jul 2010 22:50:49 +0200
X-Google-Sender-Auth: H3MSHqQ3R8z-yO2dplCDbovS14s
Message-ID: <AANLkTimXC0baa2g2UGoceFhOA7gXgNM0X0EAT122ikWm@mail.gmail.com>
Subject: Build log scripts
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduction:

I'm a fan of linux-next. A big fan. Over the past years, it has saved me lots of
time!
However, like with all itches to scratch, there are a few areas for
improvement.


The issues:

  o As a developer, I want to see if a change I made has any negative build
    impact, perhaps on an obscure architecture.
    Unless Stephen bugs me, I cannot notice easily.

  o As an architecture maintainer, I want to know if a build problem in
    platform-independent code happens for my arch only (probably my fault), or
    for many arches (maybe not my fault).

  o I want to know if there are any regressions/improvements since the previous
    version.
    The web pages do show a binary status indicator (green vs. red), but this
    doesn't help:
      - if there's a long-standing build issue (e.g. internal compiler error)
        and it's red all the time,
      - for warnings.

To solve these, I wrote a few scripts.
Of course they can be used outside the linux-next context as well.


The scripts:

  o linux-log-summary.pl

    Display a summary of all errors and warnings in one or more build logs.
    The summary is sorted by the number of occurrences.
    Optionally (using `-v'), the names of the affected build logs can be
    listed for each error or warning.
    You can combine multiple build logs by concatenating them, cfr. the
    examples below.


  o linux-log-diff.pl

    Compare two build logs and display a summary of all regressions and
    improvements.
    Line numbers and other locations (e.g. offsets inside a section for
    linker errors) are ignored in the actual comparison, only the number of
    occurrences of each error or warning is compared, to compensate for the
    addition and removal of source lines. The location information is printed
    in the summary, though.
    Again, you can combine multiple build logs.


  o linux-next-update-branch9.pl

    Helper script to parse the branch9 webpage and download the latest logs to
    branch9/$arch/$config.


Sample output:

  o summary-all.out

    Summary of all of today's builds logs, i.e. the output of

        cd branch9 && linux-log-summary.pl $(find * -type f | sort)

  o summary-all-v.out

    Summary of all of today's builds logs incl. the list of affected logfiles
    for each error or warning, i.e. the output of

        cd branch9 && linux-log-summary.pl -v $(find * -type f | sort)


  o summary-arch.out
  o summary-arch-v.out

    Summaries of all build logs per architecture, i.e. running
    linux-log-summary.pl on the result files of

        for i in branch9/*; do cat $i/* > $(basename $i); done


  o diff-all.out

    Difference between all concatenated build logs on 2010-06-27 and all
    concatenated build logs of today.


Where to find it?

I put all scripts and the sample output at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/

I hope you'll like it!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
