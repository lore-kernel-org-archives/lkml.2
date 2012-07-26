Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2GZKHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:07:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50359 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2GZKHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:07:03 -0400
Date: Thu, 26 Jul 2012 03:06:59 -0700 (PDT)
Message-Id: <20120726.030659.2063192496743861099.davem@davemloft.net>
To: hauke@hauke-m.de
Cc: torvalds@linux-foundation.org, linville@tuxdriver.com,
        brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.forshee@canonical.com, pieterpg@broadcom.com,
        brudley@broadcom.com, arend@broadcom.com, zajec5@gmail.com
Subject: Re: [PATCH] bcma: fix regression in pmu workaround reg masks
From: David Miller <davem@davemloft.net>
In-Reply-To: <1343294151-5691-1-git-send-email-hauke@hauke-m.de>
References: <1343294151-5691-1-git-send-email-hauke@hauke-m.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Thu, 26 Jul 2012 11:15:51 +0200

> This fixes a regression introduced in:
> commit b9562545ef0b13c0440ccd8d6dd4111fb77cb17a
> Author: Hauke Mehrtens <hauke@hauke-m.de>
> Date:   Sat Jun 30 01:44:41 2012 +0200
> 
>     bcma: complete workaround for BCMA43224 and BCM4313
> 
> The regression broke reading of the sprom from the chip and seamed to
> cause a change of the pci id on a BCMA43224 device so that it is
> rejected by brcmsmac. If this problem occurred, after applying this
> patch, a cold boot is needed to make the device work again.
> 
> In the original patch the workaround set the intended bits in the chip
> common core chip control registers, but the patch also unset all the
> other bits in that register, because of a wrong mask. The original
> patch was based on code from brcmsmac and there was an additional
> inversing of the mask in the code setting these regs which was missing
> here. Now the regs are set like brcmsmac did it before.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Tested-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: David S. Miller <davem@davemloft.net>
