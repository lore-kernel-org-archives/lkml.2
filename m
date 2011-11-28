Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1K1Ulo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 15:41:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:57117 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab1K1Uln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 15:41:43 -0500
Message-ID: <1322512771.23348.45.camel@pasglop>
Subject: Re: [RFC PATCH v2 4/4] cpuidle: (POWER) Handle power_save=off
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 29 Nov 2011 07:39:31 +1100
In-Reply-To: <4ED36A7D.9070308@linux.vnet.ibm.com>
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
	 <20111117112906.9191.54050.stgit@localhost6.localdomain6>
	 <1322435233.23348.19.camel@pasglop> <4ED36A7D.9070308@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 16:33 +0530, Deepthi Dharwar wrote:

> On an LPAR if cpuidle is disabled, ppc_md.power_save is still set to
> cpuidle_idle_call by default here. This would result in calling of
> cpuidle_idle_call repeatedly, only for the call to return -ENODEV. The
> default idle is never executed.
> This would be a major design flaw. No fallback idle routine.
> 
> We propose to fix this by checking the return value of
> ppc_md.power_save() call from void to int.
> Right now return value is void, but if we change this to int, this
> would solve two problems. One being removing the cast to a function
> pointer in the prev patch and this design flaw stated above.
> 
> So by checking the return value of ppc_md.power_save(), we can invoke
> the default idle on failure. But my only concern is about the effects of
> changing the ppc_md.power_save() to return int on other powerpc
> architectures. Would it be a good idea to change the return type to int
> which would help us flag an error and fallback to default idle?

I would have preferred an approach where the cpuidle module sets
ppc_md.power_save when loaded and restores it when unloaded ... but that
would have to go into the cpuidle core as a powerpc specific tweak and
might not be generally well received.

So go for it, add the return value, but you'll have to update all the
idle functions (grep for power_save in arch/powerpc to find them).

Cheers,
Ben.


