Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab0E1Vkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:40:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494Ab0E1Vkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:40:33 -0400
Date: Fri, 28 May 2010 14:40:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2] mmc: split mmc_sd_init_card()
Message-Id: <20100528144027.3c868841.akpm@linux-foundation.org>
In-Reply-To: <1-1000-12432-1274803827-7569@rere.qmqm.pl>
References: <1-1000-12432-1274803827-7569@rere.qmqm.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 18:10:28 +0200 (CEST)
Micha__ Miros__aw <mirq-linux@rere.qmqm.pl> wrote:

> This is needed to avoid code duplication in SD-combo support.

hm.  Perhaps you could have told us a bit more about it than this.

> +int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid)
> +int mmc_sd_get_csd(struct mmc_host *host, struct mmc_card *card)
> +int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
> +unsigned mmc_sd_get_max_clock(struct mmc_card *card)
> +void mmc_sd_go_highspeed(struct mmc_card *card)

These are global symbols, but they are not exported to (other) modules.
That's odd.  I'd have expected to see them either `static' or
EXPORT_MODULE()d.

I'll take the lack of a signed-off-by: and the "RFC" as signal to not
apply these patches.

