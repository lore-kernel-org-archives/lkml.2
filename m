Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1HOK1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:27:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab1HOK1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:27:09 -0400
Date: Mon, 15 Aug 2011 12:27:07 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Switch NUMA_BUILD and COMPACTION_BUILD to new
 IS_ENABLED() syntax
Message-ID: <20110815102707.GA3967@tiehlicka.suse.cz>
References: <1312989160-737-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1312989160-737-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-08-11 17:12:40, Michal Marek wrote:
> Introduced in 3.1-rc1, IS_ENABLED(CONFIG_NUMA) expands to a true value
> iff CONFIG_NUMA is set. This makes it easier to grep for code that
> depends on CONFIG_NUMA.

It looks this doesn't work properly. I can see the following build
error:
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from include/linux/kmod.h:22:0,
                 from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets.c:8:
include/linux/gfp.h: In function ‘gfp_zonelist’:
include/linux/gfp.h:265:1: error: ‘__enabled_CONFIG_NUMA’ undeclared (first use in this function)
include/linux/gfp.h:265:1: note: each undeclared identifier is reported only once for each function it appears in
include/linux/gfp.h:265:1: error: ‘__enabled_CONFIG_NUMA_MODULE’ undeclared (first use in this function)
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1

I do not have CONFIG_NUMA set so it seems to have issues with config
symbols which are not set to any value. Is this something that could be
fixed?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
