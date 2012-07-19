Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2GSReV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:34:21 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39846 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2GSReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:34:19 -0400
Date: Thu, 19 Jul 2012 19:34:15 +0200
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
Message-ID: <20120719173415.GE23393@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120714124332.GA4093@moon>
 <20120714174827.GA13319@aftab.osrc.amd.com>
 <20120719144217.GC16873@home.goodmis.org>
 <20120719164807.GD23393@aftab.osrc.amd.com>
 <1342717366.12353.48.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342717366.12353.48.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 01:02:46PM -0400, Steven Rostedt wrote:
> This is why I created the make-min-config in ktest. It keeps on
> disabling configs to see what the machine needs to boot (and optionally
> run some test), and what configs it can disable. It does not touch the
> multi options though.
> 
> It creates two configs. One that has the configs that it can't turn off
> (still enabled with a make allnoconfig, or selected by something that it
> must have), and a config that just has the configs that 'if I disable
> this, the box doesn't boot'.
> 
> Here's an example:
> 
> For my min-config files with the configs that couldn't be turned off:
> 
> $ wc -l config-min*
>   117 config-min
>   139 config-min-net
> 
> The config-min will get the box to boot (no network). The -net, adds
> enough to ssh to the box.
> 
> $ wc -l config-skip*
>  11 config-skip
>  14 config-skip-net
> 
> The above are the configs that ktest found if it disabled, would not
> boot (or ssh).
> 
> $ cat config-skip-net
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SATA_AHCI=y
> CONFIG_E1000=y
> CONFIG_QUOTA=y
> CONFIG_ATA=y
> CONFIG_UNIX=y
> CONFIG_INET=y
> CONFIG_DEVTMPFS=y
> CONFIG_EXT4_FS=y
> CONFIG_DEVTMPFS_MOUNT=y
> CONFIG_SERIAL_8250=y
> CONFIG_BLK_DEV_SD=y
> CONFIG_NET=y
> CONFIG_NETDEVICES=y
> 
> I can pass the above to a allnoconfig, and the box will boot and allow
> ssh. Note, the reason for the serial config, is that this ktest run uses
> a serial port to see if the box booted. If the serial isn't there, then
> it thinks it failed.

I agree with all this and you've explained this to me live already so
you're preaching to the choir.

But it would be a lot faster/easier if users can select, let's call'em
"profiles" which are not mutually exclusive and can speed up the
configuration process. They can either be distro-specific or generic,
selecting certain features you need.

So configuring your kernel would be like shopping without paying too
much attention to details. Let's look into the head of a person doing a
config like that and read some of her thoughts :):

"Hm, ok, this new configurator is cool, a lot faster I gotta say... So,
what do I need, ah, yes, it is an AMD laptop so from vendors I select
AMD, then I probably need ext4, then I'd like to do packet filtering
so I should enable iptables.. Oh, I'd like to do tracing too so let's
enable tracing and trust Steven with the options he's added by default,
then I need ahci, I'd also like to do encrypted partitions so I'll
enable device mapper with crypto... "

So all those things could be selectable from that profiles menu without
having to go through the gazillion of little suboptions and having to
read help (which is sometimes completely helpless) and figure out do I
need it or not.

And this would simplify configuration a lot. IMHO, anyway.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
