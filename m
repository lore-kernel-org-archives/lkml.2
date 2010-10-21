Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0JUX5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 19:57:55 -0400
Received: from relais.videotron.ca ([24.201.245.36]:26994 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0JUX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 19:57:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 21 Oct 2010 19:57:45 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-mmc@vger.kernel.org,
        Sven Neumann <s.neumann@raumfeld.com>, Chris Ball <cjb@laptop.org>,
        libertas-dev@lists.infradead.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Mack <daniel@caiaq.de>, Colin Cross <ccross@android.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@kernel.org
Subject: Re: [PATCH] sdio: fix suspend/resume regression
In-reply-to: <1287704855.12734.14.camel@maxim-laptop>
Message-id: <alpine.LFD.2.00.1010211956010.2764@xanadu.home>
References: <1286788315.3101.11.camel@sven>
 <1286955116-22793-1-git-send-email-ohad@wizery.com>
 <1287704855.12734.14.camel@maxim-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Maxim Levitsky wrote:

> This reintroduces the bug I fixed.
> 
> if the CONFIG_MMC_UNSAFE_RESUME isn't set (and that is default
> unfortunately), the host->bus_ops->resume will be NULL (see core/mmc.c
> mmc_ops), and therefore card will be removed, that will trigger a block
> device removal, sync, and deadlock).

Maybe mmc_ops should have a non NULL resume method then?


Nicolas
