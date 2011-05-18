Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1ERVEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:04:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53034 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1ERVEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:04:07 -0400
Date: Wed, 18 May 2011 17:03:40 -0400 (EDT)
Message-Id: <20110518.170340.1970357603006374415.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: devicetree-discuss@lists.ozlabs.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, miltonm@bga.com,
        sparclinux@vger.kernel.org, torvalds@linux-foundation.org,
        joy@entuzijast.net
Subject: Re: [PATCH 1/2] of: fix race when matching drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110518192100.28986.94335.stgit@ponder>
References: <20110518185751.28986.69446.stgit@ponder>
	<20110518192100.28986.94335.stgit@ponder>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 14:03:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 18 May 2011 13:21:00 -0600

> From: Milton Miller <miltonm@bga.com>
> 
> If two drivers are probing devices at the same time, both will write
> their match table result to the dev->of_match cache at the same time.
> 
> Only write the result if the device matches.
> 
> In a thread titled "SBus devices sometimes detected, sometimes not",
> Meelis reported his SBus hme was not detected about 50% of the time.
>>From the debug suggested by Grant it was obvious another driver matched
> some devices between the call to match the hme and the hme discovery
> failling.
> 
> Reported-by: Meelis Roos <mroos@linux.ee>
> Signed-off-by: Milton Miller <miltonm@bga.com>
> [grant.likely: modified to only call of_match_device() once]
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Tested on SunBlade2500 and Niagara2+

Acked-by: David S. Miller <davem@davemloft.net>
