Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0KDTIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:08:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41161 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab0KDTIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:08:16 -0400
Date: Thu, 4 Nov 2010 20:08:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marcus Meissner <meissner@suse.de>
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, tj@kernel.org, mort@sgi.com, akpm@osdl.org,
        security@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101104190804.GA16099@elte.hu>
References: <20101104100914.GC25118@suse.de>
 <20101104114648.GA23381@elte.hu>
 <20101104122906.GH25118@suse.de>
 <20101104135802.GA31416@elte.hu>
 <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104143322.GL25118@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcus Meissner <meissner@suse.de> wrote:

> > For example, on a Fedora testbox i have this version info:
> > 
> >   $ uname -r
> >   2.6.35.6-48.fc14.x86_64
> > 
> > Any attacker can download that rpm from:
> > 
> >   http://download.fedora.redhat.com/pub/fedora/linux/updates/14/x86_64/kernel-2.6.35.6-48.fc14.x86_64.rpm
> > 
> > And can extract the System.map from it, using rpm2cpio and cpio -i -d. That will 
> > include all the symbol addresses - without the attacker having any access to the 
> > System.map or /proc/kallsyms on this particular box.
> > 
> > I.e. on distro kernel installations (which comprise the _vast_ majority of our 
> > userbase) your patch brings little security benefits.
> > 
> > What i suggested in later parts of my mail might provide more security: to 
> > sandbox kernel version information from unprivileged user-space - if we decide 
> > that we want to sandbox kernel version information ...
> > 
> > That is a big if, because it takes a considerable amount of work. Would be worth 
> > trying it - but feel-good non-solutions that do not bring much improvement to 
> > the majority of users IMHO hinder such efforts.
> 
> Hiding the OS version is really quite hard I think.

Yes. Hard but it would be useful - especially if we start adding things like known 
exploit honeypots. Forcing attackers to probe the kernel by actually running a 
kernel exploit, and risking an alarm would be a very powerful security feature.

Removing version info will upset some tools/libraries that rely on kernel version 
information for quirks though.

> I mean the kernel could hide it from uname, but lsb_release, /etc/redhat-release, 
> /etc/SuSE-release etc still exist and then you can still use the fixed address 
> list table inside your exploit. But an exploits needs to have such a list, making 
> it harder to write.
> 
> If we avoid exploits being able to just do open("/boot/System.map") it would make 
> it a useful step harder for exploit writers.

Dunno. It's a very low 'barrier'.

> (This will end up a arms race between us and the exploit toolkit writers of 
> course, but hopefully not a longer one than fixing all actual problems ;)

That's not really an arms race. It's more like a 'throwing a feather in the path of 
a tornado' kind of defense. Sure, it has some effect.

> I also briefly thought about kernel ASLR, but my knowledge of the kernel loading 
> is too limited whether this is even possible or at all useful.

Now ASLR for kernel addresses would be _very_ useful. We could still 'expose' useful 
debug and instrumentation info like /proc/kallsyms, but the kernel internal offset 
would be a per bootup secret.

_That_ is a real statistical defensive security measure which would help everyone 
and everywhere. Not hiding public info on that system and still leaving the link to 
the public info (the version) available.

(Isn't such a feature available in one of the security patches? Porting that to 
distros and moving it upstream would add some real defense.)

Thanks,

	Ingo
