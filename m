Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab2EUK2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:28:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42483 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab2EUK2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:28:31 -0400
Message-ID: <4FBA18C7.4030800@linaro.org>
Date: Mon, 21 May 2012 11:28:23 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: build failure after merge of the mfd tree
References: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au> <4FB9F818.4030801@linaro.org> <20120521184005.3b7661ec6468c5878a22615d@canb.auug.org.au> <4FBA0460.1070300@linaro.org> <20120521191007.9347651e88add2e7c247a24f@canb.auug.org.au> <4FBA08A4.6030706@linaro.org> <20120521095427.GA30045@sirena.org.uk>
In-Reply-To: <20120521095427.GA30045@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since there's no dependencies which would stop it being selected
> anything like allyesconfig or randconfig might enable it.  In general
> it's normal to allow this in order to make it easier to build test
> things like subsystem wide changes.

Ah, I see. In which case Stephen was correct in that it's an issue with 
Kconfig logic (but not an issue with the patch alluded to). I'm going to 
have to pass this one over to Linus (CC'ed), as it's his train-set and I 
don't want to do the wrong thing.

Linus,

When CONFIG_AB8500_CORE is set, building ab8500-core.c and 
!(CONFIG_UX500_SOC_DB8500 | CONFIG_MFD_DB8500_PRCMU), both 
db8500-prcmu.h and dbx500-prcmu.h take it upon themselves to _both_ 
create 'return 0' inline functions for the following:

prcmu_abb_read()
prcmu_abb_write()
prcmu_config_clkout()
prcmu_ac_wake_req()
prcmu_ac_sleep_req()

I think we need a Kconfig rule to prevent this from happening, but I'm 
not sure what the correct logic would be. The other option would be to 
explicitly include db8500-prcmu.h instead of dbx500-prcmu.h in 
ab0500-core.c (which in turn includes db8500-prcmu.h (and used to 
include db5500-prcmu.h)), but this seems wrong to me.

As you have a clearer insight to these things would you care to take 
this on?

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
