Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0JRJFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:05:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33639 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752925Ab0JRJFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:05:23 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+qyUArWSWqwQpGg4IWusW6KnkEVDn9Rv20qZ6xT6
	IONXTFXkOlA8O4
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
Date: Mon, 18 Oct 2010 11:05:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6; KDE/4.4.5; i686; ; )
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>
References: <201010131328.06465.toralf.foerster@gmx.de> <201010171555.40453.toralf.foerster@gmx.de> <20101017201837.GA16458@lst.de>
In-Reply-To: <20101017201837.GA16458@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010181105.17077.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, in addition to my last mail the following patch isn't a fix, but it 
might point to the culprit.
If I apply this patch against latest tree, then the crash doesn't occur :

diff --git a/include/linux/statfs.h b/include/linux/statfs.h
index 0166d32..e336e70 100644
--- a/include/linux/statfs.h
+++ b/include/linux/statfs.h
@@ -15,8 +15,8 @@ struct kstatfs {
        __kernel_fsid_t f_fsid;
        long f_namelen;
        long f_frsize;
-   long f_flags;
        long f_spare[4];
+ long f_flags;
 };



Christoph Hellwig wrote at 22:18:37
> On Sun, Oct 17, 2010 at 03:55:39PM +0200, Toralf F?rster wrote:
> > I bisected it again w/ a fixed test script, got the same bad commit
> > script and double checked, that this commit is really the culprit which
> > crashes a user mode linux kernel at my 32bix x86 stable Gentoo running
> > 2.6.35.6 vanilla kernel as host system and 2/ gcc version 4.4.3 (Gentoo
> > 4.4.3-r2 p1.2) and glibc-2.11.2-r1 in the tool chain.
> 
> I really can't see any relation to the patch.  Can you try the some
> things in the following order, please:
> 
>  (1) git-revert 365b18189789bfa1acd9939e6312b8a4b4577b28 on current
>      Linus tree and see it it works.
>      If it works try the next, else the bisect must have been a weird
>      conicidence and I can't really help more.
>  (2) re-apply only the changes to include/asm-generic/statfs.h from
>      365b18189789bfa1acd9939e6312b8a4b4577b28 and see if that still
>      boots.
>  (3) re-apply the arch/mips/include/asm/statfs.h and
>      arch/s390/include/asm/statfs.h changes and see if it still boots
>  (4) re-apply the include/linux/statfs.h changes and see if it still
>       boots
>  (5) re-apply the fs/statfs.c changes, and by now it really shouldn't
>      boot anymore
>  (6) verify the code really is the same again as in current Linus' tree


-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

