Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab3AHJMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:12:48 -0500
Received: from tundra.namei.org ([65.99.196.166]:35281 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3AHJMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:12:44 -0500
Date: Tue, 8 Jan 2013 20:12:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
In-Reply-To: <50EB9A5E.1080306@schaufler-ca.com>
Message-ID: <alpine.LRH.2.02.1301081942030.24212@tundra.namei.org>
References: <50EB7C50.3070605@schaufler-ca.com> <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au> <50EB9A5E.1080306@schaufler-ca.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013, Casey Schaufler wrote:

> There has been an amazing amount of development in system security
> over the past three years. Almost none of it has been in the kernel.
> One important reason that it is not getting done in the kernel is
> that the current single LSM restriction requires an all or nothing
> approach to security. Either you address all your needs with a single
> LSM or you have to go with a user space solution, in which case you
> may as well do everything in user space.

This sounds like a very spurious argument.  If the development is better 
done in userspace, then do it there.

There's no way to address all your security needs with an LSM in any case, 
for any practical system.  LSM is an API for making security decisions 
about kernel flow, usually as part of implementing access control 
mechanisms.  It is not meant to provide any kind of total security 
solution, and the argument that you can't do some security in userspace is 
totally illogical.

Development should be done in userspace unless it must be done in the 
kernel.

> Multiple concurrent LSMs allows a system to be developed incrementally
> and to combine a variety of approaches that meet new and interesting
> needs. It allows for systems that are based on an LSM that does not
> meet all of the requirements but that can be supplemented by another
> LSM that fills the gaps. It allows an LSM like Smack that implements
> label based access controls to remain true to its purpose even in the
> face of pressure to add controls based on other mechanisms.
> 
> I have had requests for running Smack and AppArmor together Tetsuo has
> long had need to put SELinux and TOMOYO on the same box. Yama was
> recently special cased for stackability.

I'd say we need to see the actual use-case for Smack and Apparmor being 
used together, along with at least one major distro committing to support 
this.

Yama is special-cased and can stay that way.

SELinux and Tomoyo together makes no sense to me, and similarly, I would 
like to see the specific use-case for it and distro commitment to support 
it.

> We are looking at security from different directions than ever before.
> What good is a UID on a cell phone? I hear complaints about Android's
> "abuse" of the UID. 

What is the UID issue and how does LSM stacking address it?

> With the option of independent groups creating smallish LSMs and 
> integrating them by stacking we have the ability to make the security 
> systems modern devices require using a architecturally clean model 
> rather than hijacking existing mechanisms that work a little bit like 
> what you want to do.

This is speculative.

> 
> I used to believe in a single, integrated security module that addressed
> all the issues. Now that Linux is supporting everything from real time
> tire pressure gauges in tricycles to the global no-fly list that just
> doesn't seem reasonable. We need better turn around on supplemental 
> mechanisms. That means collections of smaller, simpler LSMs instead of
> monoliths that only a few select individuals or organizations have any
> hope of configuring properly.

If you're trying to say that only a few select individuals or orgs can 
configure things like SELinux and AppArmor properly, you're wrong, and the 
evidence for that is overwhelming.

Also, are you saying that security mechanisms are inherently easier to 
configure if they're composed from a variety of distinct modules vs. a 
monolithic scheme? 



-- 
James Morris
<jmorris@namei.org>
