Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab0KDXrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 19:47:32 -0400
Received: from 1wt.eu ([62.212.114.60]:46955 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab0KDXrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 19:47:31 -0400
Date: Fri, 5 Nov 2010 00:46:33 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: security@kernel.org, Marcus Meissner <meissner@suse.de>, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        jason.wessel@windriver.com, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101104234633.GB31256@1wt.eu>
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <20101104190804.GA16099@elte.hu> <20101104212920.GA31256@1wt.eu> <20101104215157.GA25128@elte.hu> <20101104223526.GC31236@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104223526.GC31236@1wt.eu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 11:35:26PM +0100, Willy Tarreau wrote:
> > The point is to make it riskier to run exploits - not to 'hide version because we 
> > are so buggy'. Unprivileged attackers wont be able to know whether a kernel is 
> > unpatched and wont know whether trying an actual exploit triggers a silent alarm or 
> > not.
> 
> In my opinion, hiding the distro-specific part of the version should not cause
> too much harm, but still I find this useless.

BTW, if you want to hide the kernel version for the 99% distro kernels,
there's a very simple way to do that : just don't bump EXTRAVERSION nor
the build date in official builds. Keep it the same for all the product's
life, and provide the real name in a /proc entry that is only readable by
root by default. This will solve your issue with the exact kernel version
revealing pointers/bugs without hurting compatibility with user space
tools.

That will not hide the hints I was talking about though (uptime, dir mod
time, ...) but it will provide you with a version unrelated to the bug
level.

Regards,
Willy

