Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1HDIUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:20:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57766 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1HDIUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:20:30 -0400
Date: Thu, 04 Aug 2011 01:17:49 -0700 (PDT)
Message-Id: <20110804.011749.451093446187764463.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        torvalds@linux-foundation.org
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110804.001314.1812549734453730417.davem@davemloft.net>
References: <20110804163629.e866b8f3052b7ac34dc83912@canb.auug.org.au>
	<CACxGe6ss62FFwQOk49dHqEN_35iVTSz0bFg4eH1T_iSeipiJaw@mail.gmail.com>
	<20110804.001314.1812549734453730417.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 04 Aug 2011 01:17:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 04 Aug 2011 00:13:14 -0700 (PDT)

> I think this change was stillborn when you committed it and you should
> have reviewed it more thoroughly and pushed back.

I also took a look at the one driver that's using this new interface,
and I have more disagreements.

The alias lookup unconditionally creates new aliases for the given
node and passes back an integer ID.

So even though it is implicitly creating properties, it doesn't update
the in-kernel device tree nor does it update the OpenFirmware
etc. copy.

This behvaior is undesirable and makes no sense.  This IMX serial
driver merely wants increasing incrementing indexes for the serial
nodes it finds, and there are much better ways to do that.

It also wants to see if device tree aliases have explicit port
settings, and that's fine.  The new alias code can help it do this,
but it doesn't need to create new fake aliases in order to accomplish
that task.

This stuff needs more work, I would like to suggest that you just
revert at this point.
