Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2GXBDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 21:03:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49051 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2GXBDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 21:03:47 -0400
MIME-Version: 1.0
In-Reply-To: <1343075561-17446-1-git-send-email-arnd@arndb.de>
References: <1343075561-17446-1-git-send-email-arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2012 18:03:26 -0700
X-Google-Sender-Auth: QIhfcelaf3PQMHcIyDtMSH9fMUQ
Message-ID: <CA+55aFyObNFgsaVOsjVOcH+aLjDyOgcqpvckM29T3dvugekVwg@mail.gmail.com>
Subject: Re: [GIT PULL 00/15] arm-soc: changes for v3.6
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 1:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> There are about 600 changesets in here, and a bunch of simple
> conflicts between the 15 branches, but so far no conflicts with
> stuff that you have merged already. For reference, you can check
> the "for-linus" branch in the same tree to see how we resolved
> the conflicts.

Ok, so I've merged some things a bit differently, but afaik it's all
semantically identical *except* for the merge of the file

  arch/arm/mach-omap2/clockdomains3xxx_data.c

in my merge of your "general arm-soc cleanups" pull request.

In your "for-linus" branch, "&mpu_3xxx_clkdm" remains in the
clockdomains_common[] array. In my merge, it is gone. But I think I
did the merge correctly, and you did it wrong. HOWEVER, I don't know
the code, maybe there is some subtle reason why you did it like you
did.

Your "for-linus" branch also had that

   arch/arm/arm-soc-for-next-contents.txt

file that shouldn't have been there, but whatever.

Anyway, apart from that "please check" comment, I also have small
complaint: your pull requests didn't actually point to the tags, they
pointed to the next/xyz commits. So every time I did a pull, I had to
change "next/xyz" to "tags/xyz". That's just annoying make-work. I
think it's because you just said "xyz" to the git request-pull script,
and then git had to pick one of the things and picked next. Please
disambiguate by just saying "tags/xyz" explicitly.

                  Linus
