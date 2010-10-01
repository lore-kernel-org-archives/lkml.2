Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0JAGBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:01:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:60103 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0JAGBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:01:39 -0400
Subject: Re: Odd NFS related SIGBUS (& possible fix)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org
In-Reply-To: <1285912667.2463.68.camel@pasglop>
References: <1285734825.14081.87.camel@pasglop>
	 <1285912667.2463.68.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 16:01:30 +1000
Message-ID: <1285912890.2463.71.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 15:57 +1000, Benjamin Herrenschmidt wrote:

> I actually just reproduced the lockup on x86_64 with 4 CPUs using
> mmapstress01 -p 5 -t 1.3 -f 4096.
> 
> So the trick is to mount /tmp over nfs (so that the mmap'ed file ends up
> on nfs) and run mmapstress01 as above. Then try ctrl-C it.
> 
> I'll do a bz for that one.
> 
> I'm now going to try going back kernel versions to see if I can also
> reproduce the SIGBUS or other timing issues.

So on x86 I didn't get a backtrace, but the VGA console was still
responsive somewhat, and I saw mmapstress01 there using 100% CPU and
unresponsive to kill -9 (stays in state R).

Cheers,
Ben.


