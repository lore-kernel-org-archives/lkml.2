Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab1EYK5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:57:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:53259 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1EYK5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:57:20 -0400
Date: Wed, 25 May 2011 11:57:06 +0100 (BST)
From: David Woodhouse <dwmw2@infradead.org>
X-X-Sender: dwmw2@localhost6.localdomain6
To: Ingo Molnar <mingo@elte.hu>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Song, Youquan" <youquan.song@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: linux-next: manual merge of the dwmw2-iommu tree with Linus'
 tree
In-Reply-To: <20110525091636.GC28500@elte.hu>
Message-ID: <alpine.LFD.2.02.1105251133001.3164@localhost6.localdomain6>
References: <20110525130004.150c054f.sfr@canb.auug.org.au> <20110525091636.GC28500@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Ingo Molnar wrote:

> That particular change was still under discussion and i'm not at all 
> sure we want to do it like that. So please repost the latest version.

I had not seen such discussion; I had the impression that having dealt 
with my feedback about making the thing more visible to the user, Youquan
considered the patch complete.

I am more than happy to absolve responsibility for this patch altogether 
and drop it from tree, though. It is *absolutely* the wrong approach, in 
my opinion. If the BIOS is broken and cannot cope with x2apic, the 
solution is to line the "engineers" responsible up against the wall and 
shoot them. And then to implement a "quiesce all SMI" feature that the OS 
can invoke, and make it mandatory. Presumably that's the underlying 
problem they were trying to solve?

The answer certainly isn't to add a flag in the DMAR table to opt out of 
x2apic use, when afaict the kernel is capable of using x2apic in some 
cases even when the *is* no DMAR. (Either that, or we have a lot of dead 
code in that area which *looks* like it copes with x2apic+!dmar).

I'll drop this patch from my tree when I get home and happily wash my 
hands of it. It's all yours; have fun :)

-- 
dwmw2

