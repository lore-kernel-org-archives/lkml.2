Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab1LNQHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:07:17 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43545 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab1LNQHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:07:14 -0500
Date: Wed, 14 Dec 2011 17:07:02 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/6] HWPOISON: clean up memory_failure() vs.
 __memory_failure()
Message-ID: <20111214160702.GH23589@aftab>
References: <cover.1323803130.git.tony.luck@intel.com>
 <bb20b30eaea7d0099fc2d5b0e0e5fb67b6268a8a.1323803130.git.tony.luck@intel.com>
 <20111214074749.GD25232@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214074749.GD25232@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 08:47:49AM +0100, Ingo Molnar wrote:
> > -/* dummy to break dependency. actual code is in mm/memory-failure.c */
> > -void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
> > +#ifndef CONFIG_MEMORY_FAILURE
> > +int memory_failure(unsigned long pfn, int vector, int flags)
> >  {
> >  	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
> 
> Btw., while at it, could we phrase this message in a more 
> obvious way to users, such as 'Non-fatal memory failure at %lx 
> ignored'?

Yeah, that's might not be as correct as we want it to be. AO means it
is an uncorrectable error, i.e. it will become fatal if we'd consumed
it, but it isn't that now because we just saw it passing by in the
cacheline...

Maybe "Fatal, unconsumed error ignored..."

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
