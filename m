Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2A0TlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:41:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38604 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab2A0TlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:41:03 -0500
Date: Fri, 27 Jan 2012 20:40:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120127194058.GF11715@one.firstfloor.org>
References: <20120127175342.273260614@openvz.org> <20120127175939.795551339@openvz.org> <20120127181525.GD11715@one.firstfloor.org> <20120127182403.GG11086@moon> <20120127183155.GE11715@one.firstfloor.org> <20120127184005.GH11086@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127184005.GH11086@moon>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The basic problem is if this interface is at the right level of abstraction.
> > I have some doubts on that. It seems like a long term maintenance nightmare to 
> > me. It may be better to put the loop that would call this into the kernel.
> > 
> 
> Hmm, ie selftest right in kenel?

Not testing, but more the general stability of the interface. IMHO it exposes
too many kernel internals. I know they are already exposed by clone/unshare, 
but in those nothing breaks if the user program doesn't know about some new
flags. But this looks like the user always has to be updated for every change.
I think I would prefer if more of the user was in kernel to not expose
that much.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
