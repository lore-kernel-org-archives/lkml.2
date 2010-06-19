Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0FSCPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 22:15:19 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63691 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab0FSCPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 22:15:17 -0400
To: kees.cook@canonical.com, alan@lxorguk.ukuu.org.uk
Cc: rdunlap@xenotime.net, jmorris@namei.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jkosina@suse.cz, hidave.darkstar@gmail.com,
       schwidefsky@de.ibm.com, roland@redhat.com, oleg@redhat.com,
       hpa@zytor.com, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, ebiederm@xmission.com,
       linux-doc@vger.kernel.org, sds@tycho.nsa.gov, dwalsh@redhat.com,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20100617170453.GV24749@outflux.net>
	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
	<20100617140630.c6ced27a.rdunlap@xenotime.net>
	<20100617221815.68ce30c5@lxorguk.ukuu.org.uk>
	<20100617215105.GB24749@outflux.net>
In-Reply-To: <20100617215105.GB24749@outflux.net>
Message-Id: <201006191115.BFI52612.SMLFOFVHQOFtJO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 19 Jun 2010 11:15:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> If all I cared about was the default Ubuntu distro, I wouldn't forward
> these patches at all.  As it turns out, I care about all kinds of
> configurations, e.g. people using SELinux on Ubuntu, AppArmor on SUSE,
> no LSM on Fedora, grsecurity on Gentoo, or TOMOYO on Debian.  There are
> all kinds of combinations, obviously, and I'm interested in making this
> stuff available to anyone and everyone.

Security modules supported by distributor's kernels are one of benchmarks for
Linux users when deciding distro to use. But it is just one of benchmarks.
Linux users do not decide distro only with security modules supported by
distributor's kernels. Linux users choose distro with various benchmarks.

Forcing Linux users to choose specific distro which supports SELinux in order
to use ptrace restriction is nonsense.

> The "just use SELinux" reply is tiresome.  If "everyone" used SELinux,
> there wouldn't be at least 3 other LSMs under active development.

SELinux indeed has many functionalities. But SELinux cannot provide ability to
perform restriction based on pathnames. "SELinux can do everything" is wrong.

If there were an all-in-one application that supports web browsing, mail,
writing, music, chat, scheduler etc., will "everyone" use that all-in-one
application? At least, I won't use it because it is too complicated to use.

I use X-desktop only when I need to use. I use SSH terminal if I can achieve
what I want to do. I'm not happy with spending my time for understanding how to
configure X-desktop.

Being unable to configure SELinux by Linux users leads to SELinux being
unavailable for Linux users. If something is blocked by SELinux, Linux users
simply set SELINUX=disabled in /etc/selinux/config rather than finding how to
configure SELinux because they don't know what functionalities are provided by
SELinux and which configuration is wrong.

Linux users are seeking for solutions that they can understand and configure
by themselves.

> The PTRACE, symlink, and other stuff are features people want.  If the
> point of your argument is that the logic and configuration for each
> of these features should be added to every LSM, that's not sensible.
> An end user should be able to pick and choose what they want.  If I
> create the security/hideous/ LSM tree, it would _exclude_ the ability to
> use TOMOYO or Smack or SELinux or AppArmor.

I have strong complaint about closed nature of LSM community. I believe Linux
kernel's duty is to serve userspace applications and Linux users. But whenever
discussion about access control arises, the conclusion comes from Linux kernel
developer's viewpoint rather than Linux user's viewpoint; i.e. "You can do it
using SELinux (or netfilter or whatever in-tree code). Thus spend your time for
understanding how to configure it". But that is too difficult for Linux users.

No LSM module can provide all functionalities. When users want to introduce a
security mechanism that provides specific functionalities, LSM is the only
choice. This forces users to give up other security mechanisms that provide
different functionalities because LSM is exclusive.

Windows users are picking and choosing what they want for security, and are
experiencing what combinations are good and what combinations are bad at their
own risk. But Linux users can't because LSM developers complain conflicts and
deprive Linux users of chances for experiencing what combinations are good and
what combinations are bad.

LSM modules can't be loaded upon runtime since 2.6.24. 2.6.24 strengthened the
barrier for Linux users when they want to choose different security module
because replacing vmlinux is a very very high barrier.
Linux is behind Windows regarding security hooks.
Linux kernel's duty is to serve userspace applications and Linux users, no?
Why not to provide Linux users ability to pick and choose what they want at
their own risk (rather than complaining conflicts forever)?
