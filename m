Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0DYHOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 03:14:23 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53831 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751038Ab0DYHOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 03:14:21 -0400
Date: Sun, 25 Apr 2010 09:13:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: swapping when there's a free memory
Message-ID: <20100425071349.GA1275@ucw.cz>
References: <alpine.DEB.1.10.1004220248280.19246@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1004220248280.19246@artax.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I captured this output of vmstat. The machine was freeing cache and 
> swapping out pages even when there was a plenty of free memory.
> 
> The machine is sparc64 with 1GB RAM with 2.6.34-rc4. This abnormal 
> swapping happened during running spadfsck --- a fsck program for a custom 
> filesystem that caches most reads in its internal cache --- so it reads 
> buffers and allocates memory at the same time.
> 
> Note that sparc64 doesn't have any low/high memory zones, so it couldn't 
> be explained by filling one zone and needing to allocate pages in it.

Fragmented memory + high-order allocation?

> This abnormal behavior doesn't happen everytime, it happend about twice 
> for many spadfsck attempts.

...yep, that would be random.
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
