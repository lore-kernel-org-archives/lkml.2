Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0GHGCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 02:02:13 -0400
Received: from smtp.nokia.com ([192.100.105.134]:50440 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0GHGCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 02:02:11 -0400
Subject: Re: [PATCH 1/2] mtd: m25p80: Fix false-positive probing
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Anton Vorontsov <avorontsov@mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Barry Song <21cnbao@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-mtd@lists.infradead.org, uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <20100622165734.GA20699@oksana.dev.rtsoft.ru>
References: <20100622165545.GA10255@oksana.dev.rtsoft.ru>
	 <20100622165734.GA20699@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Jul 2010 08:57:24 +0300
Message-ID: <1278568644.12733.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jul 2010 06:01:23.0480 (UTC) FILETIME=[FE737980:01CB1E62]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 20:57 +0400, Anton Vorontsov wrote:
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
> 
> [1] http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=5975
> 
> Reported-by: Mingquan Pan
> Reported-by: Barry Song <21cnbao@gmail.com>
> Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
> ---

Pushed both patches to my l2-mtd-2.6.git / dunno, added Mike's ack.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

