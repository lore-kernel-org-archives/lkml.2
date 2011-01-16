Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1APVPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:15:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47462 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1APVPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:15:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=U2Wglqam4TjfRCDT0mTu1Np5rhpOSrzadiQgVQSSXjsLTtV+PRjiAhY3sxNVAAe4lG
         cWwVX34Pl3W0dmAI1p10YzaJFLp7vemcp0BH9VGQN8rSsicCv2AdNf+Fn60noTt1nlMX
         jwpiChbzIJAPGOlWryfvsm1sxt7xA5vNUv/Bs=
MIME-Version: 1.0
In-Reply-To: <20110116185745.GB22723@ZenIV.linux.org.uk>
References: <20110116185745.GB22723@ZenIV.linux.org.uk>
Date: Sun, 16 Jan 2011 22:15:31 +0100
Message-ID: <AANLkTim1SS2Y1EL9iB2jDSUbqofoaWXig-xHa12Ogm95@mail.gmail.com>
Subject: Re: [git pull] vfs pile 2 (automount work)
From: Joachim Eastwood <manabian@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 1/16/11, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Al Viro (3):
>       sanitize vfsmount refcounting changes

f03c65993b98eeb909a4012ce7833c5857d74755 - sanitize vfsmount refcounting changes

Breaks my ARM !CONFIG_SMP compile

  CC      fs/namespace.o
fs/namespace.c: In function 'commit_tree':
fs/namespace.c:629: error: 'struct vfsmount' has no member named 'mnt_longterm'
fs/namespace.c: In function 'umount_tree':
fs/namespace.c:1192: error: 'struct vfsmount' has no member named 'mnt_longterm'
fs/namespace.c: In function 'mnt_make_longterm':
fs/namespace.c:2246: error: 'struct vfsmount' has no member named 'mnt_longterm'
fs/namespace.c: In function 'mnt_make_shortterm':
fs/namespace.c:2251: error: 'struct vfsmount' has no member named 'mnt_longterm'
fs/namespace.c:2254: error: 'struct vfsmount' has no member named 'mnt_longterm'
fs/namespace.c: In function 'dup_mnt_ns':
fs/namespace.c:2295: error: 'struct vfsmount' has no member named 'mnt_longterm'
fs/namespace.c:2299: error: 'struct vfsmount' has no member named 'mnt_longterm'
fs/namespace.c:2305: error: 'struct vfsmount' has no member named 'mnt_longterm'
fs/namespace.c: In function 'create_mnt_ns':
fs/namespace.c:2351: error: 'struct vfsmount' has no member named 'mnt_longterm'
make[1]: *** [fs/namespace.o] Error 1
make: *** [fs] Error 2

My configuration is arch/arm/configs/at91rm9200_defconfig.

regards
Joachim Eastwood
