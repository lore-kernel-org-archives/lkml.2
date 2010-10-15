Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab0JOUPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:15:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab0JOUPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:15:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 22/22] bitops: remove minix bitops from asm/bitops.h
Date: Fri, 15 Oct 2010 22:15:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com> <201010151253.15653.arnd@arndb.de> <AANLkTimK__Z_KrZ+fEUQuu51cdrYviTAmXSfQ0jD_EvP@mail.gmail.com>
In-Reply-To: <AANLkTimK__Z_KrZ+fEUQuu51cdrYviTAmXSfQ0jD_EvP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010152215.20400.arnd@arndb.de>
X-Provags-ID: V02:K0:N3+iSeQTHjF2ZwduXrwdpg+UErGRjLS/JCXl8xP1g3i
 Y7ybi1a2YqteW23IN7R+CF0MCm7AmbAV3dMkM2TN2P1GmJLvQd
 OLl+LkviLUQDWi4wS4TkE9gRYnLsWH5Ymd37vKa6nUMDVd4lnT
 JN4TOJrjTv1KGBGFlLLn7IAGp0qaGqqcCuZiujIluEJe2ITWgi
 Cz+HSfbeUfkfY3atTMywQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010 20:53:16 Mike Frysinger wrote:
> > You have defined these as "native endian":
> >
> > always LE:
> >        alpha, blackfin, ia64, score, tile, x86
> >
> > always BE:
> >        h8300, microblaze, s390, sparc
> >
> > configurable:
> >        m32r, mips, sh, xtensa
> >
> > The only ones among these that possibly ever cared about mounting minix
> > file systems on a big-endian kernel are really old sparc and mips systems,
> > everyone else probably never noticed their mistake.
> >
> > I'd say let's define the minix bitops as always LE and be done with it.
> 
> or at least make it so that this is the default, and you only have to
> update Kconfig if you need to deviate from the default.  i dont like
> having to add this minix option to every single arch Kconfig.

Yes, that would also work if we find a compelling reason to keep it that
way. You can actually keep it private to fs/minix/Kconfig by writing it
as

config MINIX_FS_NATIVE_ENDIAN
	def_bool y
	depends on H8300 || M32R || MICROBLAZE || MIPS || S390 || SUPERH || SPARC || XTENSA

We normally use select for arch specific options, but in this case I think
I would prefer the single option since we know we don't want new architectures
to do it too.

	Arnd
