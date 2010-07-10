Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab0GJVl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:41:59 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39491 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0GJVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:41:58 -0400
Date: Sat, 10 Jul 2010 23:41:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Zachary Richey <zr.public@gmail.com>
Cc: isdn@linux-pingi.de, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: isdn: Fixed warnings and odd code.
Message-ID: <20100710214156.GA15902@merkur.ravnborg.org>
References: <c40325e3d4cdc2f8c196b57c8581a0656828187c.1278796499.git.zr.public@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c40325e3d4cdc2f8c196b57c8581a0656828187c.1278796499.git.zr.public@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 05:27:29PM -0400, Zachary Richey wrote:
> This patch fixes compile time warnings in drivers/isdn/sc/init.c, and
> also cleans up what looked like redundant code in this file.


>  	outb(PRI_BASEPG_VAL, pgport);

Here we request Primary rate interface - see "PRI"

>  	msleep_interruptible(1000);
> -	sig = readl(rambase + SIG_OFFSET);
> +	sig = readl(&rambase + SIG_OFFSET);
>  	pr_debug("Looking for a signature, got 0x%lx\n", sig);
> -	if(sig == SIGNATURE)
> +	if (sig == SIGNATURE)
>  		return PRI_BOARD;
> -
> -	/*
> -	 * Try to identify a PRI card
> -	 */
> -	outb(BRI_BASEPG_VAL, pgport);

Here we request Basic rate interface - see "BRI".

So this is not redundant code and you cannot delete it.

	Sam
