Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2GMWaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:30:13 -0400
Received: from smtp10.mail.sp.isp-net.nl ([217.149.192.65]:52587 "EHLO
	smtp10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2GMWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:30:11 -0400
X-Greylist: delayed 1751 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2012 18:30:10 EDT
Message-ID: <50009A57.7000906@xmsnet.nl>
Date: Fri, 13 Jul 2012 23:59:51 +0200
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
In-Reply-To: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Language-Detected: en
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 10:37 PM, Linus Torvalds wrote:
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
 >
 >   - distro/Kconfig:
 >
 >      config DISTRO_REQUIREMENTS
 >          bool "Pick minimal distribution requirements"
 >
 >      choice DISTRO
 >          prompt "Distribution"
 >          depends on DISTRO_REQUIREMENTS
 >
 >      config FEDORA
 >      config OPENSUSE
 >      config UBUNTU
 >      ...
 >
 >      endchoice
 >
 > and then depending on the DISTRO config, we'd include one of the
 > distro-specific ones with lists of supported distro versions and then
 > the random config settings for that version:
 >
 >   - distro/Kconfig.suse:
 >
 >      config OPENSUSE_121
 >          select OPENSUSE_11
 >          select IP_NF_RAW  # ..
 >
 >   - distro/Kconfig.Fedora:
 >
 >      config FEDORA_16
 >          select FEDORA_15
 >          select DEVTMPFS               # F16 initrd needs this
 >          select DEVTMPFS_MOUNT  # .. and expects the kernel to mount
 > DEVTMPFS automatically
 >          ...
 >
 >      config FEDORA_17
 >          select FEDORA_16
 >          select CGROUP_xyzzy
 >          ...

Could this be made more dynamic? I would like to download a minimal 
config file from my distro's website and perhaps add my own minimal 
config for the hardware I own and put both downloads somewhere in my 
local tree, or have makemenuconfig ask me for a location of my minimal 
config files?

-- 
Hans
