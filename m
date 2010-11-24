Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0KXTP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:15:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35388 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0KXTP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:15:27 -0500
Date: Wed, 24 Nov 2010 19:15:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: James Jones <jajones@nvidia.com>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix find_next_zero_bit and related assembly
Message-ID: <20101124191504.GC13934@n2100.arm.linux.org.uk>
References: <1289524615-22484-1-git-send-email-jajones@nvidia.com> <4CED55A6.5090608@codeaurora.org> <alpine.LFD.2.00.1011241357520.9313@xanadu.home> <201011241108.47776.jajones@nvidia.com> <alpine.LFD.2.00.1011241412250.9313@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011241412250.9313@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 02:13:05PM -0500, Nicolas Pitre wrote:
> On Wed, 24 Nov 2010, James Jones wrote:
> 
> > On Wednesday 24 November 2010 11:00:12 am Nicolas Pitre wrote:
> > > On Wed, 24 Nov 2010, Stephen Boyd wrote:
> > > > On 11/23/2010 03:28 PM, James Jones wrote:
> > > > > On Tuesday 23 November 2010 13:26:47 Nicolas Pitre wrote:
> > > > >> On Thu, 11 Nov 2010, James Jones wrote:
> > > > >>> The find_next_bit, find_first_bit, find_next_zero_bit
> > > > >>> and find_first_zero_bit functions were not properly
> > > > >>> clamping to the maxbit argument at the bit level. They
> > > > >>> were instead only checking maxbit at the byte level.
> > > > >>> To fix this, add a compare and a conditional move
> > > > >>> instruction to the end of the common bit-within-the-
> > > > >>> byte code used by all the functions and be sure not to
> > > > >>> clobber the maxbit argument before it is used.
> > > > >>> 
> > > > >>> Signed-off-by: James Jones <jajones@nvidia.com>
> > > > >>> Tested-by: Stephen Warren <swarren@nvidia.com>
> > > > >> 
> > > > >> Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > > > >> 
> > > > >> Please send to RMK's patch system.
> > > > > 
> > > > > Thanks for the review.  It's already in the patch system, but I updated
> > > > > the entry to include your reviewed-by line.
> > > > 
> > > > Should this be sent to the stable tree too?
> > > 
> > > It could, yes.  This is hardly an urgent fix though, as the bug has been
> > > there virtually forever.
> > > 
> > > 
> > > Nicolas
> > 
> > While ancient, it does cause per-cpu allocations to fail in some situations, 
> > which generally causes panics.
> 
> That would be a good justification for the stable tree then.

And the best way to do that is _not_ to send it to stable@kernel.org,
but when you submit the patch to the patch system, add a line in
the sign-off area:

CC: <stable@kernel.org>

and when it goes into mainline (which is a requirement for stable
patches) the stable team will automatically pick it up - without anyone
needing to do any additional work.
