Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab0IHNaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:30:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41981 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0IHNaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:30:19 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Aaron Sowry <aaron@cendio.se>
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <ossman@cendio.se>
Subject: Re: Help decoding oom-killer output
References: <4C8744D1.1010405@cendio.se>
Date: Wed, 08 Sep 2010 15:30:17 +0200
In-Reply-To: <4C8744D1.1010405@cendio.se> (Aaron Sowry's message of "Wed, 08
	Sep 2010 10:09:53 +0200")
Message-ID: <87r5h4wefq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Sowry <aaron@cendio.se> writes:

> After running in to problems with the amount of vmalloc memory on a SLED
> 11 SP1 system (due to a large number of ncp mounts), we have increased
> this with the kernel parameter 'vmalloc=512M'.

This means the 32bit kernel has only about 400MB low mem virtual
address space left, large parts of it being used by the mem_map
arrays. So whole kernel has to run in 100-200MB or so which
is likely not enough.

>
> Since this change, oom-killer seems to think we are running out of
> memory,

Yes you will run out of address space all the time for kernel
operations.

Real fix is to use 64bit instead. 32bit is so 90ies.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
