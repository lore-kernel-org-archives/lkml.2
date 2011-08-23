Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1HWUKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:10:09 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44495 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab1HWUJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:09:57 -0400
Date: Tue, 23 Aug 2011 22:09:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/4] PM: Reference counting of power.subsys_data
Message-ID: <20110823200955.GA13184@atrey.karlin.mff.cuni.cz>
References: <201108090028.12698.rjw@sisk.pl> <201108090031.42691.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108090031.42691.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> Since the power.subsys_data device field will be used by multiple
> filesystems, introduce a reference counting mechanism for it to avoid
> freeing it prematurely or changing its value at a wrong time.
> 
> Make the PM clocks management code that currently is the only user of
> power.subsys_data use the new reference counting.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/Makefile    |    2 
>  drivers/base/power/clock_ops.c |   24 ++---------
>  drivers/base/power/common.c    |   86 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/pm.h             |    3 +
>  4 files changed, 95 insertions(+), 20 deletions(-)
> 
> Index: linux-2.6/drivers/base/power/common.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/base/power/common.c
> @@ -0,0 +1,86 @@
> +/*
> + * drivers/base/power/common.c - Common device power management code.
> + *
> + * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.

This looks like you now work for Renesas....?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
