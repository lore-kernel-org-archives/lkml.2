Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2LKDid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:38:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63827 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2LKDic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:38:32 -0500
Date: Mon, 10 Dec 2012 19:34:58 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com, arnd@arndb.de,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org
Subject: Re: [PATCH 00/12] Refactoring the ab8500 battery management drivers
Message-ID: <20121211033457.GA32600@lizard.sbx14280.paloaca.wayport.net>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 11:57:22AM +0000, Lee Jones wrote:
> The aim of this and subsequent patch-sets is to refactor battery
> management services provided by the ab8500 MFD. This first patch-set
> brings a few modifications to the collection which happened on the
> internal kernel, but were never Mainlined. There are lots more of
> these to come. We also tidy-up some of the Device Tree related patches
> which are currently pending in -next.

It fails to apply...

  Applying: ab8500_charger: Charger current step-up/down
  Applying: ab8500_fg: Don't clear the CCMuxOffset bit
  Applying: ab8500_btemp: Detect battery type in workqueue
  Applying: ab8500_btemp: Fix crazy tabbing implementation
  fatal: sha1 information is lacking or useless (drivers/power/ab8500_bmdata.c).
  Repository lacks necessary blobs to fall back on 3-way merge.
  Cannot fall back to three-way merge.
  Patch failed at 0001 ab8500_btemp: Fix crazy tabbing implementation

I have tried battery tree (as of eba3b670a9166a91be5a, Nov 18), I have
tried pristine Linus' tree, and I have tried linux-next. All failed in
different places.

I have tried to apply the "ab8500_btemp: Fix crazy tabbing implementation"
manually (which applied with fuzz), but then the other patches failed. So
I gave up.

What is the base of the patches?

Looking at the patch...

  diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
  index f16b60c..2623b16 100644
  --- a/drivers/power/ab8500_bmdata.c
  +++ b/drivers/power/ab8500_bmdata.c

There is really no f16b60c object in any tree, which makes me think that
you use some private tree.

Thanks,
Anton.
