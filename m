Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1C1SC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:02:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41852 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754351Ab1C1SCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:02:55 -0400
Date: Mon, 28 Mar 2011 19:02:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: Propagate uA_load requirements up supply
 chain
Message-ID: <20110328180255.GA28494@opensource.wolfsonmicro.com>
References: <1301326482-6547-1-git-send-email-collinsd@codeaurora.org>
 <1301326482-6547-3-git-send-email-collinsd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301326482-6547-3-git-send-email-collinsd@codeaurora.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 08:34:42AM -0700, David Collins wrote:
> regulator_set_optimum_mode currently only determines the load
> on the specified regulator.  Physically however, this current
> must be provided by regulators further up the supply chain.
> Add code to handle uA_load propagation up through the regulator
> supply chain.

We can't do this - current doesn't map 1:1 through a regulator, the
power consumption will map through but obviously there's a voltage
change involved and the regulators will not be 100% efficient so there
will also be some overhead from the chipld regulator.  The child
regulator needs to do the mapping in a regulator specific fashion.
