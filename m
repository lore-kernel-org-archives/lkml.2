Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab2ENWmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:42:49 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60268 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab2ENWmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:42:47 -0400
Date: Mon, 14 May 2012 18:39:52 -0400 (EDT)
Message-Id: <20120514.183952.1459413342269893446.davem@davemloft.net>
To: bpoirier@suse.de
Cc: netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfrm: take iphdr size into account for esp payload
 size calculation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336698442-25148-1-git-send-email-bpoirier@suse.de>
References: <20120511010249.GA23584@d2.synalogic.ca>
	<1336698442-25148-1-git-send-email-bpoirier@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 May 2012 15:39:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Thu, 10 May 2012 21:07:22 -0400

> -	return mtu - 2;
> +	return ((mtu - x->props.header_len - crypto_aead_authsize(esp->aead) -
> +			l3_adj) & ~(align - 1)) + (l3_adj - 2);
>  }

The formatting of this expression is completely wrong, you need
to make the "l3_adj" in the second line be aligned with the openning
parenthesis on the previous line at a depth determined based upon
how deeply in the openning parenthesis context this expression sits.

Just using TABS is ugly, and not allowed.

Use something like emacs's "C mode" with Linux coding style enabled
to assist you if you can't figure it out yourself.
