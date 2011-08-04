Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab1HDHQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:16:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:33069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab1HDHP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:15:57 -0400
Date: Thu, 04 Aug 2011 00:13:14 -0700 (PDT)
Message-Id: <20110804.001314.1812549734453730417.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        torvalds@linux-foundation.org
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <CACxGe6ss62FFwQOk49dHqEN_35iVTSz0bFg4eH1T_iSeipiJaw@mail.gmail.com>
References: <20110804142858.f7f2f128e5a038beb20aa87b@canb.auug.org.au>
	<20110804163629.e866b8f3052b7ac34dc83912@canb.auug.org.au>
	<CACxGe6ss62FFwQOk49dHqEN_35iVTSz0bFg4eH1T_iSeipiJaw@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 04 Aug 2011 00:13:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 4 Aug 2011 07:59:56 +0100

> Pull my tree now; there is a fix in there.  I'm just emailing it now.

Ugh, Grant :-/

So now you have APIs for finding information in the in-kernel copy
of the device tree which are only available for flat DT platforms?

Don't do that, please.

It makes more sense instead to have this alias munger unconditionally
work on the in-kernel copy after the device tree has been imported,
and for all ways in which the tree can be imported.

Anything else leads to fragmented interfaces for device driver
writers.

The bug is that this of_alias_scan() thing doesn't get a pointer to an
allocator function.  It needs one just like the
__unflatten_device_tree() function does.

In fact this points out that of_alias_scan() was only placed into one
of the two FT unflattening sites, it needs to go into both as well as
places that build the device tree from real OpenFirmware calls.  And
that makes an even stronger argument for adding an allocator function
pointer arg to this thing.

I think this change was stillborn when you committed it and you should
have reviewed it more thoroughly and pushed back.

