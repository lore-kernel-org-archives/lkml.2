Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab2HQLUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:20:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369Ab2HQLUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:20:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH v2 02/31] arm64: Kernel booting and initialisation
Date: Fri, 17 Aug 2012 11:20:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <1344966752-16102-3-git-send-email-catalin.marinas@arm.com> <alpine.LFD.2.02.1208161438110.1541@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208161438110.1541@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208171120.40740.arnd@arndb.de>
X-Provags-ID: V02:K0:VbR75+srgOHBqleDe1IpTeo5PfX5jDLHCM69MGIM3vT
 ZRr4UcAUf3GaJcLAV7MxX/WoxNJPQBCunk9+6uUMrONcQmEtKG
 MkRnkWFbmHzjqO3jSsdwGjmsMvaoG1xpVzqWRVbSVNjXfogRl0
 6t4GJkEtrdhFzKLCOGesYMS+wWbQBLdARyCY8QOEpkbJgnB2yA
 Hnj5buQE+6wMq++gFZJbvRu1C+ittT4qw/yDGs8f5SzCaoGLNl
 YRGEKqKgmMKOf7hGKJ84Gw4j5ETEnjCD2q367pYOS/CkHjyJju
 Qk+BlcS/fRR4VZa+vhDV3+TSTAcQ2kp0K5kqloDW/Jfweoh/CR
 OFpcU0Mt3QrPDz7pS0Lg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2012, Nicolas Pitre wrote:
> > +3. Decompress the kernel image
> > +------------------------------
> > +
> > +Requirement: OPTIONAL
> > +
> > +The AArch64 kernel does not provide a decompressor and therefore
> > +requires gzip decompression to be performed by the boot loader if the
> > +default Image.gz target is used.  For bootloaders that do not implement
> > +this requirement, the larger Image target is available instead.
> 
> Some people will want to use bzip2 or whatever other decompressor du 
> jour.  Maybe this shouldn't be gzip specific, or just presented as a 
> possible option?

Good point. Whether this should be part of this document depends on
what assumptions we make about the boot loader getting the image
in the first place.

In the strict sense, we are documenting the interface between the boot
loader and the kernel here, which already specifies that  the kernel
must be uncompressed by the time we enter it. If the boot loader wants
to add its own encryption or compression methods, or its own headers
in front of the binary, the boot protocol isn't really impacted.

That said, I think it's a good idea to also specify what kind of
format we want to be used, e.g. a stripped ELF Image compressed
with one of gzip/bzip2/lzo/xz and with no other headers added,
on a vfat/ext4/btrfs formatted file system. There are probably a
lot of other things one might want to specify if we go down this
route. Or we could refer to the UEFI spec and mandate that the
same format that UEFI uses should be used here independent of
what boot loader is used. I think we can still allow other ways to
get to the image for deeply embedded systems, e.g. linking the
kernel into the boot loader as a blob on tightly constrained
systems. For that case, we'd only specify the interface between
boot loader and kernel as described above.

	Arnd
