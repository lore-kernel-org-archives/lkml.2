Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab2FHBLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:11:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46577 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab2FHBLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:11:45 -0400
Date: Thu, 07 Jun 2012 18:11:43 -0700 (PDT)
Message-Id: <20120607.181143.231727418873766540.davem@davemloft.net>
To: joe.jin@oracle.com
Cc: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        peter.p.waskiewicz.jr@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, guru.anbalagane@oracle.com,
        adnan.misherfi@oracle.com, e1000-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] e1000e: disable rxhash when try to enable jumbo frame
 also rxhash and rxcsum have enabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FD15020.7090709@oracle.com>
References: <4FD15020.7090709@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Jin <joe.jin@oracle.com>
Date: Fri, 08 Jun 2012 09:06:40 +0800

> Upstream commit 70495a5 check if both rxhash and rxcsum enabled when enabling
> jumbo frames and disallowed all of them enabled at the same time.
> 
> Since jumbo frame widely be used in real world, so when try to enable jumbo
> frames but rxhash and rxcsum have enabled, change the default behavior to
> disable receive hashing.
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Guru Anbalagane <guru.anbalagane@oracle.com>
> Acked-by: Adnan Misherfi <adnan.misherfi@oracle.com>

If I were the Intel developers I would not apply this patch, it sets
a very bad precedence.

The tool tells you that the combination you're attempting to use is
invalid, and the kernel log message tells you exactly why.

The driver should never automatically change configuration settings
not actually requested by the user.
