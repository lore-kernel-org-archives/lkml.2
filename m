Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0LaEdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 23:33:09 -0500
Received: from mx2.netapp.com ([216.240.18.37]:58263 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0LaEdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 23:33:08 -0500
X-IronPort-AV: E=Sophos;i="4.60,253,1291622400"; 
   d="scan'208";a="500518798"
Subject: Re: still nfs problems [Was: Linux 2.6.37-rc8]
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <20101231031748.5006.qmail@science.horizon.com>
References: <20101231031748.5006.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Thu, 30 Dec 2010 23:32:48 -0500
Message-ID: <1293769968.32633.19.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 31 Dec 2010 04:32:50.0157 (UTC) FILETIME=[C82AB9D0:01CBA8A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 22:17 -0500, George Spelvin wrote: 
> > Uncached_readdir is not really a problem. The real problem is
> > filesystems that generate "infinite directories" by producing looping
> > combinations of cookies.
> > 
> > IOW: I've seen servers that generate cookies in a sequence of a form
> > vaguely resembling
> > 
> > 1 2 3 4 5 6 7 8 9 10 11 12 3...
> > 
> > (with possibly a thousand or so entries between the first and second
> > copy of '3')
> > 
> > The kernel won't loop forever with something like that (because
> > eventually filldir() will declare it is out of buffer space), but
> > userland has a halting problem: it needs to detect that every
> > sys_getdents() call it is making is generating another copy of the
> > sequence associated with '4 5 6 7 8 9 10 11 12 3'...
> 
> Huh?  This is not only an easy problem, it's a well-known problem.
> http://en.wikipedia.org/wiki/Cycle_detection
> 
> 	Here's Brent's algorithm:
> 
> 	n = 0;
> 	saved_cookie = <invalid>
> 	For each cookie {
> 		if (n && cookie == saved_cookie)
> 			die("Loop detected!");
> 		if (++n is a power of 2)
> 			saved_cookie = cookie;
> 	}
> 
> You can tweak the performance with other exponentially-growing
> functions, saving k > 1 old cookies for comparison, etc., but the
> above will work very well.


...and your point would be that an exponentially increasing addition to
the existing number of tests is an acceptable tradeoff in a situation
where the >99.999999999999999% case is that of sane servers with no
looping? I don't think so...

Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

