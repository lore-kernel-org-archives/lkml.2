Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935378Ab1IOXVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:21:02 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:40216 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932690Ab1IOXVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:21:01 -0400
Message-ID: <4E728840.407@metafoo.de>
Date: Fri, 16 Sep 2011 01:20:32 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 6/6 v3] regmap: Incorporate the regcache core into regmap
References: <1316082879-21810-1-git-send-email-dp@opensource.wolfsonmicro.com> <1316082879-21810-7-git-send-email-dp@opensource.wolfsonmicro.com> <4E721784.90302@metafoo.de> <20110915225703.GC3218@opensource.wolfsonmicro.com>
In-Reply-To: <20110915225703.GC3218@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 12:57 AM, Mark Brown wrote:
> On Thu, Sep 15, 2011 at 05:19:32PM +0200, Lars-Peter Clausen wrote:
> 
>>> +	if (!map->cache_bypass) {
>>> +		ret = regcache_read(map, reg, val);
>>> +		if (!ret) {
>>> +			mutex_unlock(&map->lock);
>>> +			return 0;
>>> +		}
> 
>> So in case regmap_readable is not true for this register regcache_read will
>> return -EIO and we'll fallback to an uncached read. This doesn't make sense in
>> my opinion. Or what are the except semantics regmap_readable supposed to be?
> 
> It's a bit interesting but falling back to asking the hardware is
> probably the right thing to do for cases where you're doing things like
> using unspecified registers to activate undocumented features - the
> register isn't really documented as being there and may do odd things
> but if the device manufacturer gives you an approved sequence then you
> can probably use it safely.

But for writes the error is propagated to the caller, instead of falling back
to a hw write. There should be at least consistency between the two.

And I think we should document that regmap_readable and regmap_writeable don't
prevent actuall hw access, but are merely meant as hints for stuff like caching.
