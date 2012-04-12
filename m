Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965936Ab2DLUDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:03:35 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41068 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab2DLUDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:03:34 -0400
Date: Thu, 12 Apr 2012 16:00:40 -0400 (EDT)
Message-Id: <20120412.160040.1086391259430365718.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ipv6/exthdrs.c et al: Optional strict PadN option
 checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333811774-3219-1-git-send-email-eldad@fogrefinery.com>
References: <CABe5r8Kygjg0O21Y5z-F=RRQCqT7ReNya+EohAJU1jauaK536Q@mail.gmail.com>
	<1333811774-3219-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Apr 2012 13:00:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Sat,  7 Apr 2012 17:16:14 +0200

> Added strict checking of PadN. PadN can be used to increase header
> size and thus push the protocol header into the 2nd fragment.
> 
> PadN is used to align the options within the Hop-by-Hop or
> Destination Options header to 64-bit boundaries. The maximum valid
> size is thus 7 bytes.
> RFC 4942 recommends to actively check the "payload" itself and
> ensure that it contains only zeroes.
> 
> See also RFC 4942 section 2.1.9.5.
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

I think you should do away with the sysctl and always perform these
checks.

At the very leat, the optlen > 7 check should always be performed.
And frankly the pad byte being zero check makes sense to do all the
time as far as I can tell too.
