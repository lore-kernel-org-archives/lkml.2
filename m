Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2HZTRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 15:17:54 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60977 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab2HZTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 15:17:53 -0400
Date: Sun, 26 Aug 2012 21:17:49 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 00/19 v2] Improve IRQ remapping abstraction in x86 core
 code
Message-ID: <20120826191749.GK3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:55:46PM +0200, Joerg Roedel wrote:
> Please review.

Finally. Usually you don't add/change code but you just move common
irq remapping pieces out of geric io-apic code and put them in once place. I
think it would be good, if you would note this in the description of your
patch.
Altogether it makes a good impression.

After browsing through the new functions in irq_remapping_modify_x86_ops() I
see that some of them test for "remap_ops" which is pointless because you don't
call irq_remapping_modify_x86_ops() if it is not the case. This also goes mostly
for irq_remapping_enabled.
The only reason when you can disable (or say irq_remapping_disable() is
called) is in the suspend path. And the remap is enabled again in via
irq_remapping_reenable() in resume. Now if this goes wrong what is next? You
don't even return an error if the callback is missing. The variable
irq_remapping_enabled does not save your ass here because some function
behave now different.

But back to the realisitic world: If something goes wrong in resume and you
can't re-enable irq remapping, the system is not really useable or is it (even
before your series)?

> Thanks,
> 
> 	Joerg
> 

Sebastian
