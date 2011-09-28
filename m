Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1I1PTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:19:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59491 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930Ab1I1PTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:19:39 -0400
Date: Wed, 28 Sep 2011 16:19:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 3/7] regmap: Add a mutex to guard the sync operation
Message-ID: <20110928151937.GM3279@opensource.wolfsonmicro.com>
References: <1317206627-6673-1-git-send-email-dp@opensource.wolfsonmicro.com>
 <1317206627-6673-3-git-send-email-dp@opensource.wolfsonmicro.com>
 <20110928125249.GH3279@opensource.wolfsonmicro.com>
 <20110928142406.GA12438@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928142406.GA12438@opensource.wolfsonmicro.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 03:24:06PM +0100, Dimitris Papastamos wrote:
> On Wed, Sep 28, 2011 at 01:52:50PM +0100, Mark Brown wrote:

> > Shouldn't we either be taking the regmap lock when doing the sync or
> > otherwise guarding against something other than a cache sync?

> Em the main issue is that the sync() implementation will use
> regmap_write() which will grab map->lock.  To avoid this we could have
> gone and used directly the lockless _regmap_write() but that's
> static.  To be honest, it feels cleaner to have only 1 lock to guard
> the map so maybe we should get rid of map->sync_lock.

Making _regmap_write() global seems fine, it's not an externally visible
API but the cache code is part of the infrastructure.
