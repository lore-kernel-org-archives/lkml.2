Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab1EaWOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:14:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422Ab1EaWOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:14:32 -0400
Date: Tue, 31 May 2011 15:13:21 -0700 (PDT)
Message-Id: <20110531.151321.494228226.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [PATCH] ip_options_compile: properly handle unaligned pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <201105292112.p4TLC6cN017178@farm-0002.internal.tilera.com>
References: <201105292112.p4TLC6cN017178@farm-0002.internal.tilera.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 May 2011 15:13:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sun, 29 May 2011 16:55:44 -0400

> The current code takes an unaligned pointer and does htonl() on it to
> make it big-endian, then does a memcpy().  The problem is that the
> compiler decides that since the pointer is to a __be32, it is legal
> to optimize the copy into a processor word store.  However, on an
> architecture that does not handled unaligned writes in kernel space,
> this produces an unaligned exception fault.
> 
> The solution is to track the pointer as a "char *" (which removes a bunch
> of unpleasant casts in any case), and then just use put_unaligned_be32()
> to write the value to memory.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Applied, thanks Chris.
