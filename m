Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812Ab0I1ADB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:03:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754256Ab0I1AC7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <4CA10545.4010204@redhat.com>
References: <4CA10545.4010204@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Sep 2010 17:02:37 -0700
Message-ID: <AANLkTikYyEPAHq5rYzzckExTSFFCAj_DUqAZEvoeU0WD@mail.gmail.com>
Subject: Re: [GIT PULL for 2.6.36] V4L/DVB fixes
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 1:57 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The following changes since commit 32163f4b2cef28a5aab8b226ffecfc6379a53786:
>
>  alpha: fix usp value in multithreaded coredumps (2010-09-25 14:38:13 -0700)
>
> are available in the git repository at:
>  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

I get

  scripts/kconfig/conf --oldconfig arch/x86/Kconfig
  drivers/media/Kconfig:146: 'endif' in different file than 'if'
  drivers/media/IR/Kconfig:15: location of the 'if'
  drivers/Kconfig:114: unexpected 'endmenu' within if block
  drivers/Kconfig:1: missing end statement for this entry
  make[1]: *** [oldconfig] Error 1
  make: *** [oldconfig] Error 2

with this. And it seems to be due to a totally broken commit at the
very beginning of the series by a commit called "Kconfig fixes"
(Hah!), that clearly has not been tested at all.

The commit sequence was also done today, apparently immediately before
sending me the pull request. Which sure as hell explains the "clearly
not tested at all" situation.

Don't do this. You are now officially on my shit-list for sending me
total crap.

How effing hard can it be to understand: you don't send me stuff that
hasn't been tested. It needs to be in -next for SEVERAL DAYS, and you
don't rebase it or take it from some random quilt series just before
sending it to me.

That's true _especially_ during the -rc series. But it's damn well
true at any other time too.

I'm angry. I expect at least some _minimal_ amount of competence from
people I pull from. This was not it. Get your ^&#! act together!

                                   Linus
