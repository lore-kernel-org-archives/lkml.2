Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065Ab2FGVqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:46:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45915 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab2FGVqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:46:17 -0400
Date: Thu, 07 Jun 2012 14:46:16 -0700 (PDT)
Message-Id: <20120607.144616.2224976714259476349.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, julia@diku.dk
Subject: Re: [PATCH 1/7] drivers/ide/ide-cs.c: adjust suspicious bit
 operation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1339018901-28439-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
	<1339018901-28439-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Wed,  6 Jun 2012 23:41:35 +0200

> -	if (!(pdev->resource[0]->flags & IO_DATA_PATH_WIDTH_8)) {
> +	if ((p1dev->resource[0]->flags & IO_DATA_PATH_WIDTH)

I'm really surprised someone as thorough as yourself did not
compile test this.

This is just more proof that it's absolutely pointless to make any
changes at all to the old IDE layer.  Nobody really cares, and the
risk %99.999 of the time is purely to introduce regressions rather
than make forward progress.
