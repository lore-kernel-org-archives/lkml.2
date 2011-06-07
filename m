Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1FGMOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:14:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43253 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab1FGMOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type;
        b=b4Jl3dW5lkZVdnkt/juozdyDwft0MOCBpDeQIpLgKJ5mFCUxDsMUGhbtc8gKXOY2yI
         vFzuwvz8etdO8/YAzPD3euJRExw9piKQc738R8lVht6jaSYm226gd5SH3JInRyJEkrlC
         +oHLD0k5IaQlQ3DnV4R/Zui2auiC9GcCVVL/o=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 7 Jun 2011 14:14:40 +0200
Message-ID: <BANLkTi=50UZsPCqmbwO=5iv8TFshCb+vfw@mail.gmail.com>
Subject: [v3.0-rc2] Creating an archive-tarball from linux-2.6 GIT repository
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as the official tarballs still missing, here some instructions to
archive a tarball from GIT repository.

[ Checkout linux-2.6 (aka linux-3.0) ]

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

( NOTE: Users from EU zone: Use <git.us.kernel.org>... it's faster for
checkouts. )

cd linux-2.6

[ gzip ]

git archive --format=tar --prefix=linux-3.0-rc2/ v3.0-rc2 | gzip -9c >
../linux-3.0-rc2.tar.gz

[ bzip2 ]

git archive --format=tar --prefix=linux-3.0-rc2/ v3.0-rc2 | bzip2 -9c
> ../linux-3.0-rc2.tar.bz2

[ xz ]

git archive --format=tar --prefix=linux-3.0-rc2/ v3.0-rc2 | xz -9c >
../linux-3.0-rc2.tar.xz

A good compromise between decompression-speed and file-size is:

[ xz -2e ]

git archive --format=tar --prefix=linux-3.0-rc2/ v3.0-rc2 | xz -2ec >
../linux-3.0-rc2.tar.xz-2e

[ Filesizes ]

$ du -h linux-3.0-rc2.tar.*
74M     linux-3.0-rc2.tar.bz2
93M     linux-3.0-rc2.tar.gz
61M     linux-3.0-rc2.tar.xz
65M     linux-3.0-rc2.tar.xz-2e

Thanks to friends from #quassel.de (git archive) and #mirbsd (xz -2e)
for the hints.
Thanks to Linus for not providing tarballs...
As I used to say... Still learning from git usecase to git usecase.

- Sedat -
