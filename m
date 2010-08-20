Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0HTWXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:23:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab0HTWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:23:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeff Mahoney <jeffm@suse.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 00/10] ioctls: Convert ten architectures to asm-generic/ioctls.h
Date: Sat, 21 Aug 2010 00:22:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.5.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mikael Starvik <starvik@axis.com>,
        Roman Zippel <zippel@linux-m68k.org>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
References: <20100820211401.651509182@suse.com>
In-Reply-To: <20100820211401.651509182@suse.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008210022.28726.arnd@arndb.de>
X-Provags-ID: V02:K0:sNCfJVrYrmmzPEHpXSWAgES978KaeYctKL4EiqiqoAf
 UZII7ZydFq07XQUxr3w9+kBd9Ln273BNFNgilMipR7/AUbJ1y5
 g8ALpt7M57M34SskNDGhOwrzZxnQEZOdEbNhxTTyijS3awBNHk
 MJSnVTl764l06NJ9+GQ6bII+/7BQuOFnid2KPxCa73+CiYv0+k
 NnGTkcJ+82XZ5tXFTIM+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 23:14:01 Jeff Mahoney wrote:
> - The generic list contains the termiox ioctl set. This seems to have
>   been added to x86 with the expectation that other arch maintainers
>   would add it to their own. New architectures have inherited this
>   automatically via asm-generic/ioctls.h and there isn't anything
>   inherently architecture specific about it. It's safe to just
>   add it to the affected architectures. If there is resistance to
>   this, I can submit a separate patchset to enable it on those
>   architectures and THEN apply this patchet, but it seems like a
>   waste of time.

Note that AFAICT there is not a single device driver that implements
the {set,get}_termiox functions, but enablign it does add extra code.

Alan added the infrastructure two years ago (see below), but it
seems we never adopted the use, or all the drivers using it were
already phased out again in the meantime.

I very much welcome making all architectures use the asm-generic/ioctls.h
file, that's why I added it in the first place. Whether or not we
actually want to have termiox support enabled without any drivers
using it is a separate question, but this would be a good time to
answer it.

	Arnd

---
commit 1d65b4a088de407e99714fdc27862449db04fb5c
Author: Alan Cox <alan@redhat.com>
Date:   Mon Oct 13 10:38:18 2008 +0100

    tty: Add termiox
    
    We need a way to describe the various additional modes and flow control
    features that random weird hardware shows up and software such as wine
    wants to emulate as Windows supports them.
    
    TCGETX/TCSETX and the termiox ioctl are a SYS5 extension that we might as
    well adopt. This patches adds the structures and the basic ioctl interfaces
    when the TCGETX etc defines are added for an architecture. Drivers wishing
    to use this stuff need to add new methods.
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

