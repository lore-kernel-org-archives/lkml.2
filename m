Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1ANLeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 06:34:50 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49505 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1ANLep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 06:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Td98VDv9fdSWdZWMg736e0oLzJLuLVENqbG1zj+gMjXj5vENg8LKeFqEjuUOhFtzUf
         2+SppJZOv6NYWaPEEpsV6thh1VqaJ3XPdCkNR2Qn4LavLxo/hLtXHiCab6Mo25bQAow0
         YPN6D6oiHRIBjG1PDRu/yJuY/dsk6HaJ3EQkE=
Subject: Re: error in 2.6.37-git10
From: Eric Dumazet <eric.dumazet@gmail.com>
To: balbi@ti.com
Cc: Piotr Hosowicz <piotr@hosowicz.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110114105639.GL2476@legolas.emea.dhcp.ti.com>
References: <4D301CA5.503@example.com>
	 <20110114095745.GD2476@legolas.emea.dhcp.ti.com>
	 <4D302067.2000203@example.com>
	 <20110114100831.GE2476@legolas.emea.dhcp.ti.com>
	 <4D3021AE.5020607@example.com> <4D302B0E.1080306@example.com>
	 <20110114105639.GL2476@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 12:34:41 +0100
Message-ID: <1295004881.3937.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 14 janvier 2011 à 12:56 +0200, Felipe Balbi a écrit :
> Hi,
> 
> On Fri, Jan 14, 2011 at 11:53:02AM +0100, Piotr Hosowicz wrote:
> > >I corrected and am building again. Hope this helps.
> > 
> > I don't know why but it failed again. I disabled and am building again.
> 
> for me it builds ok:
> 
>   CC [M]  fs/ecryptfs/dentry.o
>   CC [M]  fs/ecryptfs/file.o
>   CC [M]  fs/ecryptfs/inode.o
>   CC [M]  fs/ecryptfs/main.o
>   CC [M]  fs/ecryptfs/super.o
>   CC [M]  fs/ecryptfs/mmap.o
>   CC [M]  fs/ecryptfs/read_write.o
>   CC [M]  fs/ecryptfs/crypto.o
>   CC [M]  fs/ecryptfs/keystore.o
>   CC [M]  fs/ecryptfs/messaging.o
>   CC [M]  fs/ecryptfs/miscdev.o
>   CC [M]  fs/ecryptfs/kthread.o
>   CC [M]  fs/ecryptfs/debug.o
>   LD [M]  fs/ecryptfs/ecryptfs.o
> 
> weird.
> 

This is because it was fixed meanwhile

commit 6254b32b5791e47ba1c679d023f26985fa34755a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jan 13 17:19:38 2011 -0800

    ecryptfs: fix broken build
    
    Stephen Rothwell reports that the vfs merge broke the build of ecryptfs.
    The breakage comes from commit 66cb76666d69 ("sanitize ecryptfs
    ->mount()") which was obviously not even build tested. Tssk, tssk, Al.
    
    This is the minimal build fixup for the situation, although I don't have
    a filesystem to actually test it with.
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


