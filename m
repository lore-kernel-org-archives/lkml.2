Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2JPURY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:17:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33300 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab2JPURX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:17:23 -0400
Date: Tue, 16 Oct 2012 16:17:21 -0400 (EDT)
Message-Id: <20121016.161721.460693104731176775.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: richardcochran@gmail.com, haicheng.li@linux.intel.com,
        netdev@vger.kernel.org, tshimizu818@gmail.com,
        linux-kernel@vger.kernel.org, haicheng.lee@gmail.com
Subject: Re: [PATCH 1/2] Fix build error caused by broken PCH_PTP module
 dependency.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1350418167.2649.47.camel@bwh-desktop.uk.solarflarecom.com>
References: <1349300710.2763.8.camel@bwh-desktop.uk.solarflarecom.com>
	<20121003.204336.1981040659629176119.davem@davemloft.net>
	<1350418167.2649.47.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Tue, 16 Oct 2012 21:09:27 +0100

> I think the various kconfig options should be changed as follows:
> 
> 1. Only PTP_1588_CLOCK selects PPS.
> 2. Nothing depends on EXPERIMENTAL.  (This stuff has been in for 18
>    months and it's even being backported to RHEL 6 now.)
> 3. Either:
>    (a) The per-driver PHC options select nothing, and the driver options
>        do e.g.:
> 	select PTP_1588_CLOCK if IGB_PTP
>    (b) The per-driver PHC options are removed and the driver options do:
> 	select PTP_1588_CLOCK
>        (i.e. PHC support is unconditional)
> 
> Any objections to this, or preference for (a) vs (b)?

No objections, prefer (b).
