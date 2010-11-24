Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab0KXTIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:08:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15488 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0KXTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:08:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 24 Nov 2010 11:04:20 -0800
From: James Jones <jajones@nvidia.com>
Organization: NVIDIA
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH] ARM: Fix find_next_zero_bit and related assembly
Date: Wed, 24 Nov 2010 11:08:47 -0800
User-Agent: KMail/1.13.3 (Linux/2.6.33.4; KDE/4.4.3; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1289524615-22484-1-git-send-email-jajones@nvidia.com> <4CED55A6.5090608@codeaurora.org> <alpine.LFD.2.00.1011241357520.9313@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1011241357520.9313@xanadu.home>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011241108.47776.jajones@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 November 2010 11:00:12 am Nicolas Pitre wrote:
> On Wed, 24 Nov 2010, Stephen Boyd wrote:
> > On 11/23/2010 03:28 PM, James Jones wrote:
> > > On Tuesday 23 November 2010 13:26:47 Nicolas Pitre wrote:
> > >> On Thu, 11 Nov 2010, James Jones wrote:
> > >>> The find_next_bit, find_first_bit, find_next_zero_bit
> > >>> and find_first_zero_bit functions were not properly
> > >>> clamping to the maxbit argument at the bit level. They
> > >>> were instead only checking maxbit at the byte level.
> > >>> To fix this, add a compare and a conditional move
> > >>> instruction to the end of the common bit-within-the-
> > >>> byte code used by all the functions and be sure not to
> > >>> clobber the maxbit argument before it is used.
> > >>> 
> > >>> Signed-off-by: James Jones <jajones@nvidia.com>
> > >>> Tested-by: Stephen Warren <swarren@nvidia.com>
> > >> 
> > >> Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > >> 
> > >> Please send to RMK's patch system.
> > > 
> > > Thanks for the review.  It's already in the patch system, but I updated
> > > the entry to include your reviewed-by line.
> > 
> > Should this be sent to the stable tree too?
> 
> It could, yes.  This is hardly an urgent fix though, as the bug has been
> there virtually forever.
> 
> 
> Nicolas

While ancient, it does cause per-cpu allocations to fail in some situations, 
which generally causes panics.

Thanks,
-James
