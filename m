Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1DPSBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 14:01:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57139 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750864Ab1DPSBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 14:01:32 -0400
Date: Sat, 16 Apr 2011 19:01:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 12/13] regulator: check name in initialization of max8925
Message-ID: <20110416180140.GE25811@opensource.wolfsonmicro.com>
References: <1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-8-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-9-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-10-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-11-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-12-git-send-email-haojian.zhuang@marvell.com>
 <1302706264-25815-13-git-send-email-haojian.zhuang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302706264-25815-13-git-send-email-haojian.zhuang@marvell.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:51:03PM +0800, Haojian Zhuang wrote:
> Check name in initialization of max8925 regulator driver.

> +		if (!strcmp(ri->desc.name, pdata->constraints.name))
> +			break;

This isn't a good change - the whole point of the name in the
constraints is that it allows the user to assign an arbatrary string
which is useful for the board.  The driver should never be looking
inside the constraints at all, the core will apply the constraints for
you.
