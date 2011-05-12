Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab1ELV0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:26:42 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57894 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669Ab1ELV0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:26:41 -0400
Date: Thu, 12 May 2011 17:26:23 -0400 (EDT)
Message-Id: <20110512.172623.220889608152651989.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: af_packet: Don't initialize vnet_hdr
From: David Miller <davem@davemloft.net>
In-Reply-To: <18a010357eb63dfd50751c5eb529f6261cf90ecd.1305232529.git.joe@perches.com>
References: <18a010357eb63dfd50751c5eb529f6261cf90ecd.1305232529.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 May 2011 14:26:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 12 May 2011 13:36:10 -0700

> Save a memset, initialize only the portion necessary.
> 
> packet_snd either gets this structure completely from
> memcpy_fromiovec or uses only the hdr_len set to 0,
> so don't always initialize the structure to 0.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

On ARM this won't be tightly packed, therefore you'll leave
uninitialized pieces of padding in this structure and this
thing is an "on-the-wire" network header.

I'm not applying this.
