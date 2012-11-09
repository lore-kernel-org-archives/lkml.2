Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2KIVaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:30:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38503 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2KIVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:30:14 -0500
Date: Fri, 09 Nov 2012 16:30:12 -0500 (EST)
Message-Id: <20121109.163012.719663130136182296.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: krzysiek@podlesie.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chas@cmf.nrl.navy.mil
Subject: Re: [PATCH v3 8/7] pppoatm: fix missing wakeup in pppoatm_send()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352292734.7340.35.camel@shinybook.infradead.org>
References: <1352240222-363-1-git-send-email-krzysiek@podlesie.net>
	<1352292734.7340.35.camel@shinybook.infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 07 Nov 2012 12:52:14 +0000

> Now that we can return zero from pppoatm_send() for reasons *other* than
> the queue being full, that means we can't depend on a subsequent call to
> pppoatm_pop() waking the queue, and we might leave it stalled
> indefinitely.
> 
> Fix this by immediately scheduling the wakeup tasklet. As documented
> already elsewhere, the PPP channel's ->downl lock protects against the
> wakeup happening too soon and effectively being missed.
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ----
> Untested.
> With this sorted, Acked-By: David Woodhouse <David.Woodhouse@intel.com<
> to the other seven. Thanks.

I don't know what to do with this patch because I don't have any
context whatsoever.

So I'm tossing it, please resubmit it when it's meant to be
applied, and with some context.
