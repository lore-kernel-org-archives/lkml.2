Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab0GYWUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 18:20:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57506 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0GYWUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 18:20:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: 2.6.35 suspend regression (bisected)
Date: Mon, 26 Jul 2010 00:18:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <4C4C9E40.7070209@infracom.it>
In-Reply-To: <4C4C9E40.7070209@infracom.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007260018.14300.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 25, 2010, Roberto Oppedisano wrote:
> 
> My HP6730B (x86_64 kernel, uptodate lubuntu Lucid installed) fails to suspend
> on recent git kernels, the screen goes black (backlight on) and stays there forever.
> 
> Here's what I found from a bisect.
> 
> Alas reverting that single commit on current linux/master does not
> solve the issue so it could be that I did something wrong... anyway
> here the log of the bisect:
> 
> git bisect start
> # good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
> git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
> # bad: [815c4163b6c8ebf8152f42b0a5fd015cfdcedc78] Linux 2.6.35-rc4
> git bisect bad 815c4163b6c8ebf8152f42b0a5fd015cfdcedc78
> # good: [c316ba3b518bc35ce5aef5421135220389f4eb98] Merge branch 'linux-next' of git://git.infradead.org/ubi-2.6
> git bisect good c316ba3b518bc35ce5aef5421135220389f4eb98
> # good: [6d94d4081048756df78444a07201156f4930fe48] lis3: interrupt handlers for 8bit wakeup and click events
> git bisect good 6d94d4081048756df78444a07201156f4930fe48
> # good: [d8d326dc7ae6bec2a999d674c5babb6bf490587a] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6
> git bisect good d8d326dc7ae6bec2a999d674c5babb6bf490587a
> # bad: [9a9620db07b27700a4de9e86985735fffb78e2f8] Merge branch 'linux_next' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core
> git bisect bad 9a9620db07b27700a4de9e86985735fffb78e2f8
> # bad: [c2572b78aa0447244a38e555ebb1b3b48a0088a5] USB: cdc-acm: fix resource reclaim in error path of acm_probe
> git bisect bad c2572b78aa0447244a38e555ebb1b3b48a0088a5
> # good: [aef4b9aaae1decc775778903922bd0075cce7a88] Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
> git bisect good aef4b9aaae1decc775778903922bd0075cce7a88
> # bad: [95619be590638bd48469ac81c0f6236f349f5640] Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
> git bisect bad 95619be590638bd48469ac81c0f6236f349f5640
> # good: [92645879d07a48897fe8888c2e37607aa1189cc9] drm/radeon/kms/pm: radeon_set_power_state fixes
> git bisect good 92645879d07a48897fe8888c2e37607aa1189cc9
> # good: [ee227c577cde47f78e2df359f9c32ba047060767] of/powerpc: fix fsl_msi device node pointer
> git bisect good ee227c577cde47f78e2df359f9c32ba047060767
> # good: [d8dcaa1dc50f5aecd38d34180cd99d6af8566c88] drm/radeon/kms: make sure display hw is disabled when suspending
> git bisect good d8dcaa1dc50f5aecd38d34180cd99d6af8566c88
> # good: [03cd3739818d3fa7f973d0fb6d3aa63122ea00a0] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
> git bisect good 03cd3739818d3fa7f973d0fb6d3aa63122ea00a0
> # good: [527b9525256f97ad8d092bbfc8fdc3c5409f4a4d] n2_crypto: Fix MAU kmem_cache name.
> git bisect good 527b9525256f97ad8d092bbfc8fdc3c5409f4a4d
> # bad: [0f0a8fa735bbde4b0bc3e96e4bb2e5b380a324db] crypto: crypto4xx - Fix build breakage
> git bisect bad 0f0a8fa735bbde4b0bc3e96e4bb2e5b380a324db
> 
> Bisecting: 0 revisions left to test after this (roughly 0 steps)
> [c9aa55e5271a53d28e93fa58759d318b403c15ba] n2_crypto: Plumb fallback ahash requests properly.

Does it work if you revert that commit?

Rafael
