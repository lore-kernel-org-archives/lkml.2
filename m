Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab2AEGGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:06:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36466 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137Ab2AEGGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:06:47 -0500
Date: Thu, 5 Jan 2012 06:06:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Laxman Dewangan <ldewangan.com@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] regulator: Rail is said to be enable only if this and
	supply rails are enabled.
Message-ID: <20120105060646.GG11867@opensource.wolfsonmicro.com>
References: <1325570983-3700-1-git-send-email-ldewangan@nvidia.com> <20120103201624.GC2843@opensource.wolfsonmicro.com> <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9C2E@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9C2E@BGMAIL01.nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 11:49:14AM +0530, Laxman Dewangan wrote:

> > This feels wrong - the code in general assumes that the parents will all
> > be enabled for an enabled child (and does the required stuff on enable
> > and disable).  Doing the check isn't unreasonable but if it fails we
> > really ought to be complaining loudly as we're probably confused and
> > things might be going wrong elsewhere.

> returns true but actually the rail is not enabled because supply rail was not enabled.
> Although it is fixed in other patch but such checks help more.

You're not quite getting my point here - we should be treating this as
an error and complaining about it when we notice it, your patch will
silently mask the condition which seems likely to just cause the bug to
manifest elsewhere.
