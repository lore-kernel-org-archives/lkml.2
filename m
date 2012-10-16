Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2JPFfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:35:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48060 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459Ab2JPFfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:35:10 -0400
Date: Tue, 16 Oct 2012 14:35:00 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: core: Check before enabling regulator
 while setting constraints.
Message-ID: <20121016053458.GD8670@opensource.wolfsonmicro.com>
References: <1350365059-18838-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350365059-18838-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 10:54:19AM +0530, Yadwinder Singh Brar wrote:
> This patch adds check, whether regulator is already enabled before enabling it
> while setting machine constraints. Since some PMICs have same register bits
> for setting opmode and enabling/disabling the regulator, so it will overwrite
> the settings (if any)done by set_mode/set_suspend_mode callbacks when it
> enables regulator without checking previous status.

This sounds like a bug in the driver, these ops are supposed to be
repeatable at will.  The driver needs to remember the mode setting when
doing enable or disable, and setting the mode should not change the
enable status.
