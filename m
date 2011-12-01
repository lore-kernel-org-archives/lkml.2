Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1LASW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:22:59 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:42506 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab1LASW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:22:58 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+wZkF2v2cVvv9GEgvONVTw
Date: Thu, 1 Dec 2011 10:22:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2a/5 v2] ARM: OMAP1: select clock rate by CPU type
Message-ID: <20111201182254.GU31337@atomide.com>
References: <20111128174508.GO31337@atomide.com>
 <1322686675-26855-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <20111130222837.GR31337@atomide.com>
 <201112011110.11476.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112011110.11476.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111201 01:35]:
> On Wednesday 30 of November 2011 at 23:28:38, Tony Lindgren wrote:
> > 
> > We should also now be able to remove all the CONFIG_OMAP_ARM_XXXMHZ options
> > too, right?
> 
> Right, but then, perhaps the initial version of patch 2a/5, which 
> already started removing them, from omap1_defconfig for now, then going 
> into the right direction while unblocking another regression fix (3/5), 
> _is_ a good candidate for an rc fix?

But we did not allow dpll1 reprogramming earlier either, so we should
not need to make all these changes during the -rc cycle. I'm suspecting
that we've had this same behaviour for a really long time, and we just
have not seen it as omap1_defconfig had OMAP_CLOCKS_SET_BY_BOOTLOADER
option set.

So I'm baffled how your board would be booting at a different rate
compared to v3.1, it seems that the logic has not changed there. Or
else we have some simple bug somewhere.

Care to try to verify at what point your system started booting at
60MHz rate?

Regards,

Tony
