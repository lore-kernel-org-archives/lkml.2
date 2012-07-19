Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2GSGQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 02:16:13 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51763 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2GSGQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 02:16:10 -0400
Date: Thu, 19 Jul 2012 09:16:00 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: Andrew Victor <linux@maxim.org.za>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: Re: [PATCH 1/5] ubi: introduce ubi->bad_peb_limit
Message-ID: <20120719091600.7d55dadb@pixies.home.jungo.com>
In-Reply-To: <1342608053.7530.11.camel@brekeke>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	<1341389164-24409-2-git-send-email-shmulik.ladkani@gmail.com>
	<1342608053.7530.11.camel@brekeke>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2012 13:40:53 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> I've also amended the Kconfig text a tiny bit and dropped the defconfig
> changes - let's have them separately as a single patch at the end of the
> series.

Wouldn't having the defconfig change as the last patch break things for
those defconfigs that had explicitly set CONFIG_MTD_UBI_BEB_RESERVE
other than the default?

Meaning, if the one-before-last would be "kill CONFIG_MTD_UBI_BEB_RESERVE",
then those defconfigs that had _explicitly_ set a BEB_RESERVE value,
which do not YET set a BEB_LIMIT value, will have their BEB_LIMIT as
the default - but they actually meant a specific value other than the
default.

This is why I tried to:
- set the CONFIG_MTD_UBI_BEB_LIMIT in defconfigs as part of the commit
  which introduces this config (copy same value as their RESERVE config)
- kill all CONFIG_MTD_UBI_BEB_RESERVE references from defconfigs as part
  of the commit which kills it

Regards,
Shmulik
