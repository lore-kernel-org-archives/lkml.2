Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1GEPBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:01:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44564 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1GEPBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:01:40 -0400
Date: Tue, 05 Jul 2011 08:01:23 -0700 (PDT)
Message-Id: <20110705.080123.2174577714045488116.davem@davemloft.net>
To: loke.chetan@gmail.com
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, joe@perches.com,
        bhutchings@solarflare.com, shemminger@vyatta.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next af-packet 1/2] Enhance af-packet to provide
 (near zero)lossless packet capture functionality.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAAsGZS5vvmb_qX+cG507=hU_+kwnowEEojXGNMt5ShEZ9+ZeAA@mail.gmail.com>
References: <1308708650-25509-2-git-send-email-loke.chetan@gmail.com>
	<20110701.153633.267893668051099806.davem@davemloft.net>
	<CAAsGZS5vvmb_qX+cG507=hU_+kwnowEEojXGNMt5ShEZ9+ZeAA@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 05 Jul 2011 08:01:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chetan loke <loke.chetan@gmail.com>
Date: Tue, 5 Jul 2011 10:53:26 -0400

>> Next, having this overlay thing is entirely pointless.  Just refer to
> 
> It is useful.
> Also, future versions of the block-descriptor can append a new field.
> When that happens,
> none of the code needs to worry about the version etc for the unchanged fields.

That issue only exists because you haven't defined a common header
struct that the current, and all future, block descriptor variants can
include at the start of their definitions.

I still contend that all of these abstractions are too much and
unnecessary.

Use real data structures, not opaque "offset+size" poking into the
descriptors.
