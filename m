Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab1E0OrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 10:47:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61802 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1E0OrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 10:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=AS1hpiRwmaLj3Zpn74L5fCGDK1ORHdTFmXN23Ez6nVeE/z9CTFL8m2QQ4VyWIZn3EB
         oBisOacHT6e0whEQyp2MwxJx/DWvEOwB+NJM/WVN511ZnrxWVSN7V1knyWwAbIhze7Bm
         wM0a/gp1iNU0A9YMpJmK09H6FbQ6g2gpEINSk=
MIME-Version: 1.0
In-Reply-To: <20110527151135.cd6f758a.sfr@canb.auug.org.au>
References: <20110527151135.cd6f758a.sfr@canb.auug.org.au>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 27 May 2011 10:47:00 -0400
X-Google-Sender-Auth: AMHx7J7WUVtoS-3lzB3vXM5qPQ4
Message-ID: <BANLkTi=x=M4wwOxKjDvfiXwu6Ay0SxmkKA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:11, Stephen Rothwell wrote:
> After merging the final tree, today's linux-next build (sparc32 defconfig)
> failed like this:
>
> drivers/misc/kgdbts.c: In function 'check_and_rewind_pc':
> drivers/misc/kgdbts.c:307: error: implicit declaration of function 'instruction_pointer_set'
>
> Caused by commit 63ab25ebbc50 ("kgdbts: unify/generalize gdb breakpoint
> adjustment") from Linus' tree.
>
> Lots of architectures do not use asm-generic/ptrace.h where
> instruction_pointer_set() is defined.

yes, but lots of arches dont implement kgdb, so it doesnt matter :).
i thought i got all of them, but i must have missed some, or new
arches showed up since i wrote the patches.  i'll take a look later
today and send out a fix.
-mike
