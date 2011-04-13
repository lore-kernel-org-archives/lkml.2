Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab1DMRck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:32:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46745 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750748Ab1DMRcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:32:39 -0400
Date: Wed, 13 Apr 2011 10:32:49 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ASoC: Call snd_soc_new_widgets() after registering
 cards DAPM widgets
Message-ID: <20110413173249.GC18008@opensource.wolfsonmicro.com>
References: <1302629465-21315-1-git-send-email-lars@metafoo.de>
 <1302629465-21315-2-git-send-email-lars@metafoo.de>
 <20110413003847.GC24267@opensource.wolfsonmicro.com>
 <4DA597E3.807@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA597E3.807@metafoo.de>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 02:32:35PM +0200, Lars-Peter Clausen wrote:

> But snd_soc_dapm_new_widgets also calls dapm_power_widgets which operates on
> the passed dapm_context, will it be without any effect on the DAPM context,
> when it is called on a newly allocated context?

Yup.

> Otherwise I would say call snd_soc_dapm_new_widgets once for the cards
> dapm_context and snd_soc_dapm_sync for each codec context.

There's no point in repeatedly syncing - it may cause audible issues if
we power things off due to incomplete information.  If the sync isn't
propagating over the entire system we should fix that.
