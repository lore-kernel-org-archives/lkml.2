Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab0I0IUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:20:14 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:39828 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab0I0IUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:20:12 -0400
X-Greylist: delayed 1301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 04:20:12 EDT
Date: Mon, 27 Sep 2010 11:58:28 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rth@twiddle.net,
        linux-kernel@vger.kernel.org
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
Message-ID: <20100927075828.GA15344@jurassic.park.msu.ru>
References: <20100925181304.GV19804@ZenIV.linux.org.uk> <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com> <20100925191836.GW19804@ZenIV.linux.org.uk> <20100925192509.GX19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100925192509.GX19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 08:25:09PM +0100, Al Viro wrote:
> BTW, am I right assuming that HAE modifications is UP-only thing?  It would
> be obviously b0rken on any SMP box, since alpha_mv is not per-CPU thing...

The only SMP system that does HAE modifications at runtime is T2, so it has
a spinlock protection around set_hae() - see core_t2.h. Others are either
limited to use HAE window 0 only, or do not have HAE hardware at all.

Ivan.
