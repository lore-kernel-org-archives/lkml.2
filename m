Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0E1AXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:23:08 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:36888 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0E1AXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:23:06 -0400
Date: Thu, 27 May 2010 20:22:46 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Arjan van de Ven <arjan@infradead.org>, x86@kernel.org,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for select
 intel processors
In-reply-to: <87ocg1jts7.fsf@deeprootsystems.com>
Message-id: <alpine.LFD.2.00.1005272009490.24823@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <e099975ca65a7f6ac7f8bc3fee84d3e03893aa31.1274926772.git.len.brown@intel.com>
 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
 <87ljb5l9d5.fsf@deeprootsystems.com> <20100527072207.2e783b1e@infradead.org>
 <87ocg1jts7.fsf@deeprootsystems.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> >  drivers/idle/intel_idle.c       |  446

> >> Any reason this arch-specific driver needs to be in drivers/idle
> >> instead of under a platform specific dir like arch/x86?

> To me that would be much less convenient as I expect to maintain my
> platform-specific CPUidle driver along with the rest of my
> platform-specific code.

I guess the reason is conveneince of the maintainer (me).

A good case could be made to put this driver under
drivers/cpuidle/, arch/x86/, drivers/platform/x86/,
as well as drivers/idle/ -- and maybe someplace else
that I didn't think of.

Maybe if I maintained all of arch/x86/, then I'd naturally
propose putting it someplace under arch/x86/.  But like i7300_idle,
it runs on only a sub-set of x86 boxes, so it seemed to
make sense to put it with i7300_idle.

BTW. There is an sfi_idle driver in the pipeline as well
with the same naming issue.  It is x86 specific, sfi-specific,
and cpuidle-specific -- so a case could be made to put it in
arch/x86/, drivers/sfi/, drivers/cpuidle/ -- but it will
just as likely land in drivers/idle/.

cheers,
Len Brown, Intel Open Source Technology Center
