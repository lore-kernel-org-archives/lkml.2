Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1ERVEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:04:13 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53035 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab1ERVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:04:09 -0400
Date: Wed, 18 May 2011 17:03:52 -0400 (EDT)
Message-Id: <20110518.170352.92788672093555496.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: devicetree-discuss@lists.ozlabs.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, miltonm@bga.com,
        sparclinux@vger.kernel.org, torvalds@linux-foundation.org,
        joy@entuzijast.net
Subject: Re: [PATCH 2/2] drivercore: revert addition of of_match to struct
 device
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110518192105.28986.53198.stgit@ponder>
References: <20110518185751.28986.69446.stgit@ponder>
	<20110518192105.28986.53198.stgit@ponder>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 14:03:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 18 May 2011 13:21:05 -0600

> Commit b826291c, "drivercore/dt: add a match table pointer to struct
> device" added an of_match pointer to struct device to cache the
> of_match_table entry discovered at driver match time.  This was unsafe
> because matching is not an atomic operation with probing a driver.  If
> two or more drivers are attempted to be matched to a driver at the
> same time, then the cached matching entry pointer could get
> overwritten.
> 
> This patch reverts the of_match cache pointer and reworks all users to
> call of_match_device() directly instead.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Tested on SunBlade2500 and Niagara2+

Acked-by: David S. Miller <davem@davemloft.net>
