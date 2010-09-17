Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0IQTIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 15:08:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab0IQTIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 15:08:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, Andi Kleen <andi@firstfloor.org>,
        containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] fs/exec.c: provide the correct process pid to the pipe helper
In-Reply-To: Eric W. Biederman's message of  Thursday, 16 September 2010 13:12:31 -0700 <m1zkvh4fdc.fsf@fess.ebiederm.org>
References: <1284663599-3549-1-git-send-email-wad@chromium.org>
	<20100916193543.GA11016@redhat.com>
	<m1zkvh4fdc.fsf@fess.ebiederm.org>
Emacs: ballast for RAM.
Message-Id: <20100917190800.D2C4B403E8@magilla.sf.frob.com>
Date: Fri, 17 Sep 2010 12:08:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That said I don't think this is a complete fix.  We also potentially
> have the same issue with the uts namespace and the user namespace.

True.

> I believe the core file holds all of this information relative to the
> process that is dying, one elf note or other so we don't need to worry
> about information loss.

That's correct (see linux/elfcore.h, pr_*id fields in prstatus and prpsinfo).

> I can imagine that it would be nice to have different core patterns
> depending on where you are in the process tree, so a container can
> do something different than the system outside of the container.  Are
> you thinking along those lines, or are you imagining something else?

I agree.  The format string being part of the pid_ns makes sense to me.  
(I don't have any ideas about the interface for setting it.)
Of course, then what would make most sense is for the pipe handler to
run in the innermost namespace that set its own format, rather than in
the global ns.


Thanks,
Roland
