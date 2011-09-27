Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1I0TLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 15:11:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43568 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab1I0TLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 15:11:00 -0400
Date: Tue, 27 Sep 2011 20:10:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/5] regmap: Implement regcache_cache_bypass helper
 function
Message-ID: <20110927191058.GY4289@opensource.wolfsonmicro.com>
References: <1317119108-15338-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1317119108-15338-3-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317119108-15338-3-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 11:25:05AM +0100, Dimitris Papastamos wrote:
> Ensure we've got a function so users can enable/disable the
> cache bypass option.

Given that the sync code is fiddling about with this value internally
without taking care to preserve the external state I don't think we can
expose this to users yet.  We need to make sure it plays nicely with the
sync code somehow, probably by preserving the state at the start of the
sync and restoring it afterwards.
