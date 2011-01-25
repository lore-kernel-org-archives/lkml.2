Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1AYW2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:28:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48038
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624Ab1AYW2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:28:52 -0500
Date: Tue, 25 Jan 2011 14:29:26 -0800 (PST)
Message-Id: <20110125.142926.246535705.davem@davemloft.net>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 14/20] staging/appletalk: remove the BKL
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295993854-4971-15-git-send-email-arnd@arndb.de>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
	<1295993854-4971-15-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 25 Jan 2011 23:17:28 +0100

> This changes appletalk to use lock_sock instead of
> lock_kernel for serialization. I tried to make sure
> that we don't hold the socket lock during sleeping
> functions, but I did not try to prove whether the
> locks are necessary in the first place.
> 
> Compile-tested only.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

If you're moving appletalk to staging because "nobody is motivated
enough to remove the BKL" and then you actually do the work to remove
the BKL, I really don't see any point in doing the whole staging
thing.

We always keep an eye on every protocol that sits under the top-level
net/.  Every socket API change propagates, as does every other
networking API change that matters for those protocols.

You can move appletalk down to staging if that stops happening, which
it won't.
