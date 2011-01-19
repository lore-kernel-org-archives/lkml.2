Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1ASQSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:18:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab1ASQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:18:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH 4/4] BKL: move CONFIG_BKL to staging
Date: Wed, 19 Jan 2011 17:17:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <1295385422-3592-1-git-send-email-arnd@arndb.de> <1295385422-3592-5-git-send-email-arnd@arndb.de> <20110119154419.GA21411@elliptictech.com>
In-Reply-To: <20110119154419.GA21411@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101191717.58277.arnd@arndb.de>
X-Provags-ID: V02:K0:kVj5DgVJ2ZddQCtOclopTpxEwZ3FEc7Mvn0N1Ne6N4g
 g4bkJMDMQ6w3l4xp8aWUV6dqWpB2Fqse21+Xh6ZDqJmDm8pVVp
 wr1q1HHMv3JthCQKg1ctCeKus68Zo3SE/jUWr9GydsucbANTJh
 6VQDoXHzfHa+IS3352k5F2kWOR/GhAGFIA9f/SPSt6Gf7isXGB
 tg1BfbBGD57Q6nJ91HfNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 January 2011, Nick Bowler wrote:
> I think this patch is not very nice.  It will cause working kernel
> configurations to turn into broken kernel configurations when the user
> does 'make oldconfig', with no warning.
> 
> These drivers that use the BKL work fine.  Removing working features
> with no adequate replacement available seems like a serious regression
> to me.

I wouldn't call it a serious regression since the code is still there
and both the symptom and the solution are rather obvious. What's more
important is to make any people still relying on the code aware that
it's going away unless someone fixes it, so they have the chance to
send patches or pay someone to fix it for them.

The remaining drivers that are still relying on the BKL are very
rarely used and for the less obscure ones (ufs, ipx and x.25), people
have volunteered to fix them (though I have seen no proper patches
for these yet). For the rest, I suppose if nobody complains, they
can actually go away, according to the logic that if nobody is using
them, they most likely are broken anyway and more a security risk than
they are worth.

Anyway, it seems that you're lucky this time, because I managed to miss
the merge window by being away from my test box for the most part of it.

	Arnd
