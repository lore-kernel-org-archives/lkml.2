Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2GTJr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:47:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab2GTJrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:47:53 -0400
Date: Fri, 20 Jul 2012 11:47:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
In-Reply-To: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1207201145310.16218@twin.jikos.cz>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Linus Torvalds wrote:

> So this has long been one of my pet configuration peeves: as a user I
> am perfectly happy answering the questions about what kinds of
> hardware I want the kernel to support (I kind of know that), but many
> of the "support infrastructure" questions are very opaque, and I have
> no idea which of the them any particular distribution actually depends
> on.
> 
> And it tends to change over time. For example, F14 (iirc) started
> using TMPFS and TMPFS_POSIX_ACL/XATTR for /dev. And starting in F16,
> the initrd setup requires DEVTMPFS and DEVTMPFS_MOUNT. There's been
> several times when I started with my old minimal config, and the
> resulting kernel would boot, but something wouldn't quite work right,
> and it can be very subtle indeed.
> 
> Similarly, the distro ends up having very particular requirements for
> exactly *which* security models it uses and needs, and they tend to
> change over time. And now with systemd, CGROUPS suddenly aren't just
> esoteric things that no normal person would want to use, but are used
> for basic infrastructure. And I remember being surprised by OpenSUSE
> suddenly needing the RAW table support for netfilter, because it had a
> NOTRACK rule or something.
> 
> The point I'm slowly getting to is that I would actually love to have
> *distro* Kconfig-files, where the distribution would be able to say
> "These are the minimums I *require* to work". So we'd have a "Distro"
> submenu, where you could pick the distro(s) you use, and then pick
> which release, and we'd have something like

I agree that this would be very nice to have exactly for the reasons you 
have pointed out.

[ ... snip ... ]
> and then depending on the DISTRO config, we'd include one of the
> distro-specific ones with lists of supported distro versions and then
> the random config settings for that version:
> 
>  - distro/Kconfig.suse:
> 
>     config OPENSUSE_121
>         select OPENSUSE_11
>         select IP_NF_RAW  # ..
> 
>  - distro/Kconfig.Fedora:
> 
>     config FEDORA_16
>         select FEDORA_15
>         select DEVTMPFS               # F16 initrd needs this
>         select DEVTMPFS_MOUNT  # .. and expects the kernel to mount
> DEVTMPFS automatically
>         ...
> 
>     config FEDORA_17
>         select FEDORA_16
>         select CGROUP_xyzzy
>         ...
> 
> and the point would be that it would make it much easier for a normal
> user (and quite frankly, I want to put myself in that group too) to
> make a kernel config that "just works".

But we'll first have to make 'select' to actually work, right? It 
currently doesn't resolve the dependencies of the selected configs, so it 
will just produce some very broken config.

-- 
Jiri Kosina
SUSE Labs

