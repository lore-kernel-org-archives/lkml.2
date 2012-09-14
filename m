Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083Ab2INVpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:45:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40991 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760063Ab2INVpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:45:36 -0400
Date: Fri, 14 Sep 2012 23:45:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120914214532.GA6468@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nikolay Ulyanitsky <lystor@gmail.com>,
	Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic>
 <1347658843.7172.90.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1347658843.7172.90.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:40:43PM +0200, Peter Zijlstra wrote:
> Hmm, cute. What kind of machine did you test it on? Nikolay's machines
> look to be smallish AMD X6 or ancient Intel c2d (the patch will indeed
> have absolutely no effect on a dual core).

Yep, I took an X6 too. So it's a single-socket, 6-core AMD, F10h.

> I'll see about running pgbench on a bigger Intel tomorrow if Mike
> doesn't beat me to it.

Can try that too on one of the bigger machines I have, if needed.

> The problem the patch is trying to address is not having to scan an
> entire package for idle cores on every wakeup now that packages are
> getting stupid big.
> 
> Regressing Postgres otoh isn't nice either..
> 
> Anyway, I guess I'm fine with nixing this patch until we figure out
> something smarter..
> 
> I'm also curious to know wth postgres does that this patch makes such a
> big difference...

I'm using 9.1 in Debian testing while Nikolay is using 9.2.

Thanks.

-- 
Regards/Gruss,
    Boris.
