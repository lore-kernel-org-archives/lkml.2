Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2HFKXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:23:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34964 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316Ab2HFKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:23:16 -0400
Date: Sat, 4 Aug 2012 15:32:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Liam Girdwood <lrg@ti.com>, matthias@kaehlcke.net,
        kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] sound/soc/soc-core.c: drop kfree of devm_kzalloc's
 data
Message-ID: <20120804143200.GD15691@opensource.wolfsonmicro.com>
References: <1344081632-4729-3-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344081632-4729-3-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 02:00:32PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Using kfree to free data allocated with devm_kzalloc causes double frees.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)

Might it make more sense to devm_kfree() them?  If we don't expect to
immediately abort driver instantiation it'll save having them lying
around for the entire lifetime of the device even if they're not
strictly leaked.
