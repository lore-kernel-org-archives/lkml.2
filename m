Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab0KGJD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 04:03:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51291 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab0KGJDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 04:03:54 -0500
Date: Sun, 7 Nov 2010 10:03:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to
 reduce ease of attacking
Message-ID: <20101107090337.GC23843@elte.hu>
References: <20101104100914.GC25118@suse.de>
 <20101104114648.GA23381@elte.hu>
 <20101104122906.GH25118@suse.de>
 <20101104135802.GA31416@elte.hu>
 <20101104141104.GA31753@elte.hu>
 <20101104143322.GL25118@suse.de>
 <20101104190804.GA16099@elte.hu>
 <20101104212920.GA31256@1wt.eu>
 <20101104215157.GA25128@elte.hu>
 <20101104223526.GC31236@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104223526.GC31236@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> > An 'exploit honeypot' would be some small amount of 'detection' code for the 
> > exploitable pattern of parameters (most attacks come via ioctls so we can add 
> > detection for known holes without any performance hit), and the kernel would 
> > warn the sysadmin that an exploit attempt has occured.
> 
> If we pollute the ioctl code with all the CVEs we have accumulated over the years, 
> I bet we'd get a performance hit and will probably introduce new bugs due to the 
> harder to maintain code.

That's just wrong, because it's usually not the same ioctl hit with dozens of CVEs, 
but lots of CVEs are spread out amongst lots of ioctls. You need to come up with 
something more concrete than "I bet" to support that claim ;-)

> > The point is to make it riskier to run exploits - not to 'hide version because 
> > we are so buggy'. Unprivileged attackers wont be able to know whether a kernel 
> > is unpatched and wont know whether trying an actual exploit triggers a silent 
> > alarm or not.
> 
> In my opinion, hiding the distro-specific part of the version should not cause too 
> much harm, but still I find this useless.
>
> 
> You see, I've used the vmsplice exploit at one place. Do you know how I did ? $ 
> cat /etc/redhat-release
> 
> Then I opened the box and installed the DVD showing the same version on a spare PC 
> to experiment with it. Once I got the exploit to reliably work without crashing 
> the kernel nor leaving traces, I dared launching it on the target machine and it 
> worked. Uname -r was not involved there. [...]

Sigh, you _still_ have not understood my point and you clearly dont seem to know how 
honeypots work.

An 'exploit honeypot' kernel feature, on a patched kernel, would at that point warn 
the admin that local user XXX tried to run an exploit.

The point is that the attacker cannot know whether it's safe to run the exploit on 
the box (will result in a compromise), or is not safe to run the exploit (the 
honeypot code will warn the admin).

Uname -r fuzzing is not needed because the attacker 'needs to run it' to compromise 
a vulnerable system (as you seem to believe). It's done because if the attacker runs 
it on a _not vulnerable machine_, it keeps him from running the exploit.

In short, it removes the 'is it safe to try this exploit' information from the 
system - and if there's also a honeypot there, it introduces a real (and if done 
well enough, undetectable) risk of detection for the attacker.

Thanks,

	Ingo
