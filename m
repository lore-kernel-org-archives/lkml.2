Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2AIImS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:42:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57316 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab2AIImQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:42:16 -0500
Date: Mon, 9 Jan 2012 00:41:51 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lrg@ti.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] regulator: Add S5M8767A regulator driver
Message-ID: <20120109084150.GK22134@opensource.wolfsonmicro.com>
References: <1325225153-32389-1-git-send-email-sbkim73@samsung.com>
 <20120109072515.GE22134@opensource.wolfsonmicro.com>
 <01d901cccea9$af3b8490$0db28db0$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01d901cccea9$af3b8490$0db28db0$@com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 05:35:47PM +0900, Sangbeom Kim wrote:

> After delete above functions, Is it right to code like below?

> +static struct regulator_ops s5m8767_buck_ops = {
> +	.enable	 = s5m8767_reg_enable,
> +	.disable	 = s5m8767_reg_disable,
> +	.set_suspend_enable	= s5m8767_reg_enable,
> +	.set_suspend_disable	= s5m8767_reg_disable,

No.  If your hardware doesn't have this feature your driver shouldn't
pretend it does, and if such a mapping were a good way of implementing
this we'd be better doing it in the core.
