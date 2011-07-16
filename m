Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1GPXhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 19:37:50 -0400
Received: from smtp13.ono.com ([62.42.230.16]:12588 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752488Ab1GPXht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 19:37:49 -0400
Date: Sun, 17 Jul 2011 01:37:46 +0200
From: JA =?ISO-8859-1?B?TWFnYWxs824=?= <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: autofs@linux.kernel.org
Subject: Re: [autofs] autofs does not resolve names ?
Message-ID: <20110717013746.5c5e477a@werewolf.home>
In-Reply-To: <1310783458.3171.2.camel@perseus.themaw.net>
References: <20110716030141.3e6916e3@werewolf.home>
	<1310783458.3171.2.camel@perseus.themaw.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jul 2011 10:30:58 +0800, Ian Kent <raven@themaw.net> wrote:

(CC LKML for info and completeness...)

> On Sat, 2011-07-16 at 03:01 +0200, JA Magallón wrote:
> > Hi all...
> > 
> > Since the update to autofs-5.0.6, I have a curious problem. Probably it is not autofs
> > to blame, but I ask here to see if someone can give me some light...
> 
> Have you applied autofs-5.0.6-fix-ipv6-name-for-lookup-fix.patch?
> Which fixes a stupid mistake on my part.
> 

Love you ! That did the trick, everything works again.

Are you planning to release a 5.0.7 with the fix ?

> > 
> > Setup:
> > /etc/autofs/auto.master:
> > 
> > /home   ldap://danae-nfs.cps.unizar.es/automountMapName=auto_home,o=diis --timeout=60,tcp,nobrowse
> > 
> > (user homes map from LDAP, shared homes at a server)
> > 
> > The name is resolved:
> > 
> > annwn:/etc/autofs# host danae-nfs
> > danae-nfs.cps.unizar.es has address 155.210.152.202
> > annwn:/etc/autofs# ping danae-nfs
> > PING danae-nfs.cps.unizar.es (155.210.152.202) 56(84) bytes of data.
> > 64 bytes from danae-nfs.cps.unizar.es (155.210.152.202): icmp_req=1 ttl=255 time=0.339 ms
> > ...
> > 
> > But when I access home (ssh the box):
> > 
> > Jul 15 01:39:31 annwn automount[7774]: Starting automounter version 5.0.6, master map auto.master
> > Jul 15 01:39:31 annwn automount[7774]: using kernel protocol version 5.02
> > Jul 15 01:39:31 annwn automount[7774]: lookup_nss_read_master: reading master files auto.master
> > ...
> > Jul 15 01:39:31 annwn automount[7774]: mount_mount: mount(nfs): root=/home name=magallon what=danae-nfs:/export/home/usuarios/giga/magallon, fstype=nfs, options=tcp,quota
> > Jul 15 01:39:31 annwn automount[7774]: mount_mount: mount(nfs): nfs options="tcp,quota", nobind=0, nosymlink=0, ro=0
> > Jul 15 01:39:31 annwn automount[7774]: get_nfs_info: called with host danae-nfs(69.65.19.116) proto udp version 0x30
> > Jul 15 01:39:37 annwn automount[7774]: get_nfs_info: called with host danae-nfs(69.65.19.116) proto tcp version 0x30
> > 
> > Where the hell does it get that IP address for my server ????
> > 
> > Diggin a bit more:
> > 
> > annwn:/var/log# host 69.65.19.116
> > 116.19.65.69.in-addr.arpa domain name pointer nx-deleted-host-1.no-ip.com
> > 
> > because I have at /etc/resolv.conf:
> > 
> > search cps.unizar.es unizar.es no-ip.org
> > 
> > Why did it not resolved first with the first domain ?
> > 
> > If I delete the no-ip.org domain, I get:
> > 
> > Jul 15 01:47:18 annwn automount[8068]: mount_mount: mount(nfs): root=/home name=magallon what=danae-nfs:/export/home/usuarios/giga/magallon, fstype=nfs, options=tcp,quota
> > Jul 15 01:47:18 annwn automount[8068]: mount_mount: mount(nfs): nfs options="tcp,quota", nobind=0, nosymlink=0, ro=0
> > Jul 15 01:47:20 annwn automount[8068]: add_host_addrs: hostname lookup failed: Name or service not known
> > Jul 15 01:47:20 annwn automount[8068]: mount(nfs): no hosts available
> > Jul 15 01:47:20 annwn automount[8068]: dev_ioctl_send_fail: token = 28
> > Jul 15 01:47:20 annwn automount[8068]: failed to mount /home/magallon
> > 
> > automount does not add the search domains and resolve ? what am I doing wrong ?
> > is it a bug ? uuhhh ?
> > 
> > TIA
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
J.A. Magallon <jamagallon()ono!com>     \                 Winter is coming...
