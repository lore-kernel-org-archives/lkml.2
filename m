Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0L3TRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:17:41 -0500
Received: from smtp-out.google.com ([74.125.121.67]:52487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab0L3TRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 14:17:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=oYYVHhfAoBitYiZ6kE2hO0pcEW1p+CADGedUdug2vGd4DdjuFIcBhZV2oUJwxHFYd0
         Pn8k6IOxwtdSOcRI0pMQ==
Date: Thu, 30 Dec 2010 11:17:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>
cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] init: rename CONFIG_EMBEDDED to CONFIG_EXPERT
In-Reply-To: <201012301350.28862.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1012301055340.12995@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com> <20101230124535.GA3306@sgi.com> <201012301350.28862.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010, Arnd Bergmann wrote:

> > Doesn't this patch series break the 'bisectable' rule for patches?
> > I think you can get by with adding a CONFIG_EXPERT selects CONFIG_EMBEDDED
> > in the first patch and the last patch removing that same selects.
> 
> How about leaving it that way during the merge window even? That would
> help people sending git pull requests that add new dependencies on
> CONFIG_EMBEDDED. David can submit another patch that removes the
> temporary CONFIG_EMBEDDED option along with any new users in -rc2
> or for 2.6.39 then.
> 

Ok, so there are a few pending EMBEDDED dependency additions in linux-next 
as of next-20101230, which should be a pretty good indicator of what type 
of conflict we might risk during the merge window.

 - three new defconfig files:

	89ba4d12: arch/arm/configs/ag5evm_defconfig
	6cfce27c: arch/arm/configs/omap1_defconfig 
	d58f0967: arch/blackfin/configs/BF561-EZKIT-SMP_defconfig 

 - 3ce05168 (drm/kms: load fbcon from drm_kms_helper)

 - b595076a (tree-wide: fix comment/printk typos)

Instead of CONFIG_EXPERT select CONFIG_EMBEDDED, we could add a ninth 
patch which does CONFIG_EMBEDDED select CONFIG_EXPERT and tag it in some 
way so we know it's only temporary for the merge window to find new 
CONFIG_EMBEDDED entries.

Andrew, this would be going through your -mm tree anyway, so how would you 
prefer to merge it?
