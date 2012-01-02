Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2ABLkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 06:40:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60571 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab2ABLkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 06:40:53 -0500
Date: Mon, 2 Jan 2012 11:40:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Donggeun Kim <dg77.kim@samsung.com>, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl, rdunlap@xenotime.net, cbouatmailru@gmail.com,
        pali.rohar@gmail.com, prakity@mavell.com, lars@metafoo.de,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH] regulator: add regulator_force_disable() definition for
 !CONFIG_REGULATOR
Message-ID: <20120102114049.GD2899@opensource.wolfsonmicro.com>
References: <20111228110550.GB24405@opensource.wolfsonmicro.com>
 <1325497772-1817-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325497772-1817-1-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 06:49:32PM +0900, MyungJoo Ham wrote:
> regulator_force_disable() was omitted in consumer.h for
> !CONFIG_REGULATOR case.

Applied, thanks.  

> +static inline int regulator_force_disable(struct regulator *regulator)
> +{
> +	return 0;
> +}
> +

I do think this'd be better returning an error - unlike the other stub
functions ignoring the attempt to force disable isn't within the bounds
of normal behaviour and if the consumer is trying to force disable at
all it's probably pretty urgent that the disable actually happens.
