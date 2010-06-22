Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab0FVR4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:56:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49365 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab0FVR4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DLcpIYNU2dg7wAHnlVA4gOeCWMVdzvku1nw/kOHKbr6wAQ7jSQOSXsMDFN8wUdlu5m
         OcJhxbA83bLxO8trUd0qDPPaUu4jOf/kHiXaxutL3Y/MdpF/EKA8GhLbjkToTs/pwSFs
         JQArwGhyO+IE4b4Y7X1qq8ET5JAi67hzKoxM0=
MIME-Version: 1.0
In-Reply-To: <20100622165734.GA20699@oksana.dev.rtsoft.ru>
References: <20100622165545.GA10255@oksana.dev.rtsoft.ru> <20100622165734.GA20699@oksana.dev.rtsoft.ru>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 22 Jun 2010 13:56:00 -0400
Message-ID: <AANLkTinP63VyX2LjY-zIbnluasCiT3tOv6tlfZ6k1WqM@mail.gmail.com>
Subject: Re: [PATCH 1/2] mtd: m25p80: Fix false-positive probing
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Barry Song <21cnbao@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 12:57, Anton Vorontsov wrote:
> Since commit 18c6182bae0acca220ed6611f741034d563cd19f ("Rework
> probing/JEDEC code"), m25p80 driver successfully registers chips
> even if JEDEC probing fails.
>
> This was needed to support non-JEDEC flashes. Though, it appears
> that some platforms (e.g. blackfin bf533 stamp[1]) used the old
> behavior to detect if there's any flash connected, so the driver
> have to fail on JEDEC probing errors.
>
> This patch restores the old behavior for JEDEC flashes, and adds
> "-nonjedec" SPI device IDs for M25Pxx flashes, so that the kernel
> still supports non-JEDEC flashes.

Acked-by: Mike Frysinger <vapier@gentoo.org>

> [1] http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=5975

http://blackfin.uclinux.org/gf/tracker/5975

> Reported-by: Mingquan Pan

<Grace.Pan@analog.com>
-mike
