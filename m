Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0J1GzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 02:55:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab0J1GzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 02:55:18 -0400
Date: Thu, 28 Oct 2010 08:54:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grazvydas Ignotas <notasas@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: -tip: origin tree build failure (battery-2.6.git related)
Message-ID: <20101028065457.GA29856@elte.hu>
References: <20101026144118.GA9335@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101026144118.GA9335@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

* Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> Hello Linus,
> 
> Please pull battery-2.6.git tree to receive changes prepared for
> 2.6.37.
> 
> There are three new drivers, various small cleanups and bug fixes.
> [...]
>
> Grazvydas Ignotas (1):
>       power_supply: Add driver for TWL4030/TPS65950 BCI charger

Today's -tip fails to build due to upstream commit 2e727f1 ("power_supply: Add 
driver for TWL4030/TPS65950 BCI charger"), on every x86 build that has this driver 
enabled (for example allyesconfig or allmodconfig):

 drivers/power/twl4030_charger.c: In function ‘twl4030_clear_set_boot_bci’:
 drivers/power/twl4030_charger.c:105: error: ‘TWL4030_PM_MASTER_BOOT_BCI’ undeclared (first use in this function)
 drivers/power/twl4030_charger.c:105: error: (Each undeclared identifier is reported only once
 drivers/power/twl4030_charger.c:105: error: for each function it appears in.)
 drivers/power/twl4030_charger.c: In function ‘twl4030_bci_have_vbus’:
 drivers/power/twl4030_charger.c:137: error: ‘TWL4030_PM_MASTER_STS_HW_CONDITIONS’ undeclared (first use in this function)

The new driver does not build at its own commit point either, as the missing symbol 
definition is simply not there. It appears that commit 2e727f1 could not have been 
build-tested by anyone before it got upstream (let alone boot and functionality 
tested). As a temporary workaround i'm disabling it in -tip.

Thanks,

	Ingo
