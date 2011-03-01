Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1CADvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 22:51:07 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:50473 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835Ab1CADvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 22:51:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAC78a015LFEb/2dsb2JhbACmSnW7RA2FVAQ
Date: Tue, 1 Mar 2011 14:51:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Otto Meier <gf435@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [regression]2.6.38-rc6 with XFS still does consume all free
 space
Message-ID: <20110301035101.GH3087@dastard>
References: <4D63A9E7.3000803@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D63A9E7.3000803@gmx.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 01:19:51PM +0100, Otto Meier wrote:
> Hello,
> on my System a "make modules_install" with kernel 2.6.38-rc6 has eaten up
> all free Space on a XFS partition.

Are you building the 2.6.38-rc6 kernel on some other kernel or are
you running 2.6..38-rc6?

> The free Space is
> 
> /dev/sda6             56472984  43613692  12859292  78% /
> 
> after make modules_install i get
> 
> /dev/sda6             56472984  56472964        20 100% /

Had you already built the kernel, or did the make command build the
kernel and all the modules before installing them?  Can you check
how much space the modules directory is actually using (i.e. using
du)?

Also, did you get an ENOSPC error?

> with kernel 2.6.37.1 everything runs fine and df shows
> 
> /dev/sda6             56472984  43262256  13210728  77% /
> 
> any idea what is going on here?

No, all the known preallocation regressions have been fixed. can you
confirm that the kernel you are running has this commit in it?

b8fc826 xfs: speculative delayed allocation uses rounddown_power_of_2 badly

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
