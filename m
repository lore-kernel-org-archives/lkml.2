Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab0FJOKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:10:38 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52758 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab0FJOKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:10:37 -0400
Date: Thu, 10 Jun 2010 17:14:02 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
       "catalin.marinas@arm.com" <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM: unwind extension
Message-ID: <20100610141402.GY17639@pcarmody-desktop>
References: <1275567442-11370-1-git-send-email-ext-phil.2.carmody@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275567442-11370-1-git-send-email-ext-phil.2.carmody@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 10 Jun 2010 14:10:13.0760 (UTC) FILETIME=[A5180800:01CB08A6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/10 14:17 +0200, Carmody Phil.2 (EXT-Ixonos/Helsinki) wrote:
> 
> The first two patches are simply preparation for the third, making it
> effectively trivial, even though it's the only one with a concrete 
> change in behaviour.
> 
> The origins of this patchset are the discovery that unwind and kmemleak
> don't always cooperate well with each other - any allocation within 
> an exit or devexit function causes kmemleak to look up symbols that 
> aren't in any unwind table. This of course means that all WARN_ONs and
> BUGs will suffer the same fate.
> 
> It could certainly be said that with a typical system the linked list
> has grown too large to be practical as a container, and some improvements
> could be made in that direction in the future.

Catalin, 

Have you had a chance to look at these yet? The linked-list efficiency
issue I mention in the final paragraph above is a no-brainer; I have a 
1-line tweak that improves the real-world efficiency so much that on 
average there are only 2 linked list operations rather than (on a 50+
module system) 70. However, that patch is orthogonal to the above set, 
so I'll not mix the two.

Phil
