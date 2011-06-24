Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1FXLTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:19:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60095 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754488Ab1FXLTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:19:32 -0400
Date: Fri, 24 Jun 2011 12:19:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-kernel@vger.kernel.org, ti@lists.linaro.org,
        linux-omap@vger.kernel.org, lrg@ti.com, sameo@linux.intel.com,
        Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCH] regulator: twl: Add 'fixed' set_voltage callback
Message-ID: <20110624111929.GC9483@opensource.wolfsonmicro.com>
References: <1308862014-11212-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308862014-11212-1-git-send-email-jaswinder.singh@linaro.org>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 02:16:54AM +0530, Jassi Brar wrote:
> Define dummy set_voltage callback for fixed lines,
> without which voltage constraints fail to apply.
> 
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>

No, this isn't sensible - fixed voltage regulators aren't an unusual
property of this device, they've very common.  The core should handle
this gracefully.  Probably whatever consumer is doing the setting also
ought to be updated to check that the voltages it wants to set are
supported at startup since otherwise it can end up repeatedly trying to
set something that'll never work.
