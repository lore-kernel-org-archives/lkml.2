Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1CQI33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:29:29 -0400
Received: from lebrac.rtp-net.org ([88.191.135.105]:54721 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1CQI31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:29:27 -0400
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv3 3/3] ARM: mx51: Add support for low power suspend on MX51
Organization: RtpNet
References: <1300305787-7970-1-git-send-email-Dinh.Nguyen@freescale.com>
	<1300305787-7970-2-git-send-email-Dinh.Nguyen@freescale.com>
	<1300305787-7970-3-git-send-email-Dinh.Nguyen@freescale.com>
	<20110317082106.GT29521@pengutronix.de>
Date: Thu, 17 Mar 2011 09:29:03 +0100
In-Reply-To: <20110317082106.GT29521@pengutronix.de> (Sascha Hauer's message
	of "Thu, 17 Mar 2011 09:21:06 +0100")
Message-ID: <87sjumrvzk.fsf@lebrac.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> writes:

Hi,

> On Wed, Mar 16, 2011 at 03:03:07PM -0500, Dinh.Nguyen@freescale.com wrote:
>> +
>> +struct clk *gpc_dvfs_clk;
>> +
>> +static int mx5_suspend_enter(suspend_state_t state)
>> +{
>> +	if (gpc_dvfs_clk == NULL)
>> +		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs_clk");
>
> clk_get can fail and NULL can be a valid clock.

So, I guess one may want to fail here if one can't get the clock. The
suspend will fail in hard to debug way if this clock is not enabled
at this point.

Arnaud
