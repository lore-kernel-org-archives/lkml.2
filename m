Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab0G3MvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 08:51:18 -0400
Received: from swm.pp.se ([212.247.200.143]:51097 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691Ab0G3MvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 08:51:17 -0400
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jul 2010 08:51:16 EDT
Date: Fri, 30 Jul 2010 14:40:46 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-kernel@vger.kernel.org
Subject: Re: MD raid and different  elevators  (disk i/o schedulers) (fwd)
Message-ID: <alpine.DEB.1.10.1007301434080.9875@uplift.swm.pp.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, this might be more appropriate for lkml (or is there another place?) 
because people with knowledge of how these layers interact might be here 
and not on linux-raid-ml ?

If block cache is done on all levels and readahead is done on all levels, 
then quite a lot of redundant block information is going to exist in 
memory for all these layers? I can understand that it might make sense to 
keep block cache for the fs and perhaps for the drive layer, but 
md->dm(crypto)->lvm layers this might make less sense?

What about default readahead for these devices? Doing readahead on dm 
device might be bad in some situations, perhaps good in others?

---------- Forwarded message ----------
Date: Thu, 29 Jul 2010 12:53:35 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Fabio Muzzi <liste@kurgan.org>
Cc: linux-raid@vger.kernel.org
Subject: Re: MD raid and different  elevators  (disk i/o schedulers)

On Thu, 29 Jul 2010, Fabio Muzzi wrote:

> Is this true? Are there compatibility issues using different i/o schedulers 
> with software raid?

I'd actually like to raise this one level further:

In the case of (drives)->md->dm(crypto)->lvm->fs, how do the schedulers, 
readahead settings, blocksizes, barriers etc interact thru all these layers? Is 
block caching done on all layers? Is readahead done on all layers?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
