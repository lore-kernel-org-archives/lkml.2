Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab2FFSym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:54:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38316 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2FFSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:54:41 -0400
Date: Wed, 06 Jun 2012 11:54:40 -0700 (PDT)
Message-Id: <20120606.115440.1245419453265419850.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: eric.dumazet@gmail.com, bhutchings@solarflare.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v9] tilegx network driver: initial support
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FCFA312.4020505@tilera.com>
References: <201206042023.q54KNEZp003834@farm-0002.internal.tilera.com>
	<1339004459.26966.31.camel@edumazet-glaptop>
	<4FCFA312.4020505@tilera.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 6 Jun 2012 14:36:02 -0400

> By the way, your question about tx_queue_len is a good one; I'm roping in
> our other network developer folks to figure it out.  Originally it was a
> performance optimization, I believe; I'm not sure it's still required. 

It's illegal, you cannot do this.

If you set the TX queue length to zero, amongst other very serious
and grave problems, your device cannot be used with the various
packet scheduler queueing disciplies.

Zero TX queue lengths should only be used for layering drivers which
are purely software entities rather than for real actual hardware.

As stated before, all of the areas where the tilegx driver tries to be
different end up being bugs.  It would therefore be nice, if, as I
suggested before, the driver is audited by you against a known
gold-standard Linux driver such as tg3 to spot inconsistencies like
this.
