Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0GHIvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 04:51:17 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:40553 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab0GHIvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 04:51:16 -0400
Date: Thu, 8 Jul 2010 10:51:14 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zachary Amsden <zamsden@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
	point for pvclock
Message-ID: <20100708085114.GM15122@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Gleb Natapov <gleb@redhat.com>, Glauber Costa <glommer@redhat.com>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Zachary Amsden <zamsden@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Avi Kivity <avi@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <20100707135140.GI2707@mothafucka.localdomain> <20100707143338.GK15122@anguilla.noreply.org> <20100707151540.GH4689@redhat.com> <20100707200536.GL15122@anguilla.noreply.org> <20100708053100.GJ4689@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
In-Reply-To: <20100708053100.GJ4689@redhat.com>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jul 2010, Gleb Natapov wrote:

> > > And what if you provide -cpu qemu64,-kvmclock to qemu command line?
> > 
> > Adding that to the glob of options that already were there from libvirt
> > didn't disable it, but using an LD_PRELOAD wrapper[1] to that purpose on
> > the host when starting kvm did help.
> > 
> Strange. -kvmclock should have had the same effect. What qemu is it?
> What is your command line?

| QEMU PC emulator version 0.11.1 (qemu-kvm-0.11.1), Copyright (c) 2003-2008 Fabrice Bellard
from the debian package qemu-kvm (0.11.1+dfsg-1~bpo50+1)

/usr/bin/kvm -S -M pc-0.11 -enable-kvm -m 512 -smp 1 -name zoe -uuid 1885e784-c831-4ef8-9576-8eaa9abf3a8b -monitor unix:/var/lib/libvirt/qemu/zoe.monitor,server,nowait -boot c -drive file=/dev/vg_sookie_system/zoe-boot,if=ide,bus=0,unit=0,boot=on -drive file=/dev/vg_sookie_system/zoe-root,if=virtio -drive file=/dev/vg_sookie_system/zoe-swap,if=virtio -net nic,macaddr=00:16:36:40:00:0b,vlan=0,model=virtio,name=net0 -net tap,fd=25,vlan=0,name=hostnet0 -net nic,macaddr=00:16:36:40:05:0b,vlan=1,model=virtio,name=net1 -net tap,fd=28,vlan=1,name=hostnet1 -serial none -parallel none -usb -vnc 127.0.0.1:10 -vga cirrus -balloon virtio

And I had added "-cpu qemu64,-kvmclock" to that at either the front or the end.

Cheers,
[should we trim the CC list?  If yes, to what?]
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
