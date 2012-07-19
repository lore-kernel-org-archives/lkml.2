Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2GSQsM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:48:12 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39789 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab2GSQsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:48:10 -0400
Date: Thu, 19 Jul 2012 18:48:07 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, Pekka Enberg <penberg@kernel.org>,
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
Message-ID: <20120719164807.GD23393@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120714124332.GA4093@moon>
 <20120714174827.GA13319@aftab.osrc.amd.com>
 <20120719144217.GC16873@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719144217.GC16873@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 10:42:17AM -0400, Steven Rostedt wrote:
> On Sat, Jul 14, 2012 at 07:48:27PM +0200, Borislav Petkov wrote:
> > 
> > Let's have an example: when I have to build upstream on a distro here,
> > I take the distro config and use it despite that it takes a long time
> > to build since everything is module - it is still better for me to
> > wait that one time instead of doing a dozen of trial and errors after
> > forgetting a config option each time.
> 
> This is where 'make localmodconfig' does help. It can remove a lot of
> modules for you. And I just recently fixed a bug in the tool that it now
> removes even more modules (The fix is in linux-next).

Even more modules? When is enough, enough? :-)

> Also, if you are building on another box than what the kernel is for,
> you can go to that box and run 'lsmod > /tmp/lsmod'. Copy that file to
> the build machine (into /tmp/lsmod), and then run
> 'make LSMOD=/tmp/lsmod localmodconfig', and this will remove the modules
> not used by the target box.

Seriously, this helps only in the cases where the stuff the distro
actually needs is in modules. So, there probably are obscure situations
where you need to enable stuff which is bool and not M. Hopefully those
cases are seldom enough so thanks for this, I'll try that the next time.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
