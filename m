Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2AXGr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 01:47:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50573 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2AXGr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 01:47:26 -0500
Date: Tue, 24 Jan 2012 10:47:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
Message-ID: <20120124064719.GA29735@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.258631438@openvz.org>
 <20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:16:55AM +0900, KAMEZAWA Hiroyuki wrote:
...
> > 
> > Index: linux-2.6.git/arch/x86/include/asm/kcmp.h
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.git/arch/x86/include/asm/kcmp.h
> > @@ -0,0 +1,17 @@
> > +#ifndef _LINUX_KCMP_H
> > +#define _LINUX_KCMP_H
> > +
> > +/* Comparision type */
> > +enum {
> > +	KCMP_FILE,
> > +	KCMP_VM,
> > +	KCMP_FILES,
> > +	KCMP_FS,
> > +	KCMP_SIGHAND,
> > +	KCMP_IO,
> > +	KCMP_SYSVSEM,
> > +
> > +	KCMP_TYPES,
> > +};
> > +
> > +#endif /* _LINUX_KCMP_H */
> 
> Why under /arch ?
> 

Hi Kame,

because I've tested it under x86 only. Once someone
confirm it's needed on some else arch and does work
as expected -- it wont be a problem to make it system
wide. Until then -- I think better to stick with
at least tested case.
...
> > +
> > +static long kptr_obfuscate(long v, int type)
> > +{
> > +	return (v + cookies[type][0]) ^ cookies[type][1];
> > +}
> > +
> 
> I'm sorry could you add comments to swho what this does ?

The idea is disorder the in-memory order but remain order
suitable for sorting. Anywa, as Peter pointed this helper
must be redone. I'll post updated version.

> 
> It seems this function itself doesn't depend on arch.
> 

Yes, it doesn't. But as I said if someone confirm it's
needed on non-x86 and get tested, that will not be a
problem to make it system-side.

	Cyrill
