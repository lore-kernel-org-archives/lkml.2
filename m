Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1GDIzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:55:08 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:31227 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756632Ab1GDIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:55:07 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/RUiH4/btFgWhtATu98QnW
Date: Mon, 4 Jul 2011 01:55:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rajendra Nayak <rnayak@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
        Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] OMAP: hwmod: add kernel cmdline flag to avoid
 resetting IP blocks during init
Message-ID: <20110704085503.GQ23145@atomide.com>
References: <20110703010204.19046.85186.stgit@dusk>
 <20110703010206.19046.85293.stgit@dusk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110703010206.19046.85293.stgit@dusk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [110702 17:58]:
> On some boards, it's not possible to reset certain IP blocks during
> kernel initialization.  Some boards connect GPIO lines to external
> voltage controllers, so resetting them may cause voltage to drop on a
> critical supply[1].  Other boards connect GPIO lines to reset pins on
> external devices without open documentation, so if the GPIO blocks are
> reset, the external devices cannot currently be reconfigured[2].
> 
> The correct way to fix these issues on OMAP is to add a
> hwmod_no_setup_reset(hwmod) call to the board file, that references
> the IP block that must preserve its state.  This allows the OMAP core
> code to reset the remaining IP blocks.
> 
> However, during initial bring-up of a new board, it may be desirable
> to not reset any IP block, for ease of debugging.  This patch adds a
> kernel command line parameter, 'hwmod_no_setup_reset', that prevents
> the OMAP hwmod code from resetting any IP block during init.
> 
> 1. Nayak, Rajendra.  _[PATCH 7/7] 4460sdp/blaze/panda: hwmod: Prevent
>    gpio1 reset during hwmod init_.  1 July 2011.  E-mail to the
>    linux-omap@vger.kernel.org mailing list.  Retrieved from
>    http://www.mail-archive.com/linux-omap@vger.kernel.org/msg51992.html
> 
> 2. Buesch, Michael.  _Nokia n810 LCD (MIPID/blizzard) on 2.6.38_.  28
>    Feb 2011.  E-mail to the linux-omap@vger.kernel.org mailing list.
>    Retrieved from http://www.spinics.net/lists/linux-omap/msg47277.html

Also related is the gptimer12 on secure omaps as reported by Aaro.
 
> +	hwmod_no_setup_reset
> +			[OMAP] During kernel initialization,
> +			prevent the subarchitecture code from resetting
> +			IP blocks before the driver loads.  Useful for
> +			initial bring-up of boards which require some
> +			bootloader configuration to be retained on GPIO or
> +			other IP blocks.
> +

How about just make it hwmod_reset=1 with 0 being the default value
for now?

Regards,

Tony
