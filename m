Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0KDBuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 21:50:25 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:53505 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab0KDBuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 21:50:21 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Nov 2010 21:50:21 EDT
Message-ID: <4CD20F85.7040005@asbjorn.biz>
Date: Thu, 04 Nov 2010 01:42:29 +0000
From: =?UTF-8?B?QXNiasO4cm4gU2xvdGggVMO4bm5lc2Vu?= <asbjorn@asbjorn.biz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: fix Architecture field when cross compiling
References: <1288654261-8269-1-git-send-email-asbjorn@asbjorn.biz> <4CD1E8C4.2020405@suse.cz>
In-Reply-To: <4CD1E8C4.2020405@suse.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 10:57 PM, Michal Marek wrote:
> I know very little about debian packaging, but shouldn't this be done in
> all cases, regardless of CROSS_COMPILE being set or not? You even show
> in the above example that in some cases you don't need CROSS_COMPILE to
> build a kernel for a different architecture.

I had a problem earlier with Kbuild ignoring ARCH if CROSS_COMPILE
wasn't set, but can't reproduce with the current kernel, but I also
started out with upgrading it from .26, since squeezes .32 doesn't work
on Soekris net4501. So this is no longer an issue.

The other reason for make it dependent on CROSS_COMPILE at least to
begin with is that the ARCH -> debarch translation table doesn't have to
be as complete since it doesn't break anything in the currently working
non-cross compile senario. If this doesn't matter then I will send a new
patch, that doesn't depend on CROSS_COMPILE being set.

I have CC'ed the debian-kernel list, for people not on LKML:
https://patchwork.kernel.org/patch/296182/
