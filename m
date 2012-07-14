Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2GNRsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 13:48:52 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:60694 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2GNRsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 13:48:43 -0400
Date: Sat, 14 Jul 2012 19:48:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120714174827.GA13319@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120714124332.GA4093@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714124332.GA4093@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 04:43:32PM +0400, Cyrill Gorcunov wrote:
> For example to enable "PCI driver for virtio devices" I need to go to
> Device Drivers -> Virtio drivers, while I think it would be great to
> have everything virt. related in Virtualization section.

Actually, we need something more generic than that: everything X-related
should be automatically selected when setting CONFIG_X. And X can be any
subset of configuration options which belong to one feature, be it KVM,
distro-specific stuff, or CPU-vendor specific stuff, or whatever.

I can imagine, for example, that when a user wants to have an
AMD-specific config, it automatically selects CPU_SUP_AMD, X86_MCE_AMD
(for MCE), MICROCODE_AMD (microcode support), AGP_AMD64, EDAC_AMD64 and
a bunch of other AMD-specific features.

This would simplify not only the configuration process but also
Kconfig-related build failures since for your configuration you'll make
sure that required stuff is selected.

What I'm saying is that not only distro-specific configs but also some
sort of hierarchical config options could be defined to automatically
preselect stuff for a specific aspect and save a lot of time when
configuring a new system. Our config options have grown humongous right
about now and we can use the simplification. Of course, you can always
do fine-grained tuning afterwards but it'll save a lot of time, in
general.

Let's have an example: when I have to build upstream on a distro here,
I take the distro config and use it despite that it takes a long time
to build since everything is module - it is still better for me to
wait that one time instead of doing a dozen of trial and errors after
forgetting a config option each time.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
