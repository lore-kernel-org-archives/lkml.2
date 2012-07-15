Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2GOVTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 17:19:15 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33732 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2GOVTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 17:19:05 -0400
Date: Sun, 15 Jul 2012 23:18:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120715211848.GA21167@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120715101434.GA18144@aftab.osrc.amd.com>
 <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 01:17:16PM +0300, Pekka Enberg wrote:
> > Yes, something like KVMTOOL_TEST_ENABLE except not a make target but a
> > Kconfig option.
> 
> It is a config option too - "make kvmconfig" simply enables it.

Right, so how about something more concrete in this whole discussion:

Maybe add the KVMTOOL_TEST_ENABLE (maybe rename it to a more fitting
name like KVM_OPTS or similar) thing to a new toplevel Kconfig menu
called "Distro and other profiles" or so:

  │ │                                       General setup  --->
  │ │                                       Distros and other profiles  --->			<---
  │ │                                   [*] Enable loadable module support  --->
  │ │                                   [*] Enable the block layer  --->
  │ │                                       Processor type and features  --->
 ...

Btw, which Kconfig option is needed for "-usbdevice tablet" support so
that the host mouse can be able to send scroll events to the guest qemu
screen without the need for the qemu screen to capture it so that I need
to "escape" it everytime I need to return to the host? And can we add it
to the list of options KVMTOOL_TEST_ENABLE selects?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
