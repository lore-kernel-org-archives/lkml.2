Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1AUMN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 07:13:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35448 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754458Ab1AUMNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 07:13:55 -0500
Date: Fri, 21 Jan 2011 12:13:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kim Kyuwon <q1.kim@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Convert bd2802 driver to dev_pm_ops
Message-ID: <20110121121352.GD8186@opensource.wolfsonmicro.com>
References: <1295559395-28942-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110120151201.8dca7a7e.akpm@linux-foundation.org>
 <20110120232409.GA23862@opensource.wolfsonmicro.com>
 <20110120153528.4a535065.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120153528.4a535065.akpm@linux-foundation.org>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 03:35:28PM -0800, Andrew Morton wrote:

> It's tricky to get the compiler/linker to discard code and data without
> triggering an unused-var warning.  cpu_notifier() does it by emitting a
> reference:

SIMPLE_DEV_PM_OPS() is being a bit more brute force than that - it
just defines out the reference if compiled without PM_SLEEP.  You still
need the ifdefs around the function definitions, but not their uses.
