Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab1FPPPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:15:13 -0400
Received: from mail03-md.ns.itscom.net ([175.177.155.113]:49644 "EHLO
	mail03-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab1FPPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:15:08 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "viro@ZenIV.linux.org.uk Viro" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, mszeredi@suse.cz
In-Reply-To: <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu> <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
Date: Fri, 17 Jun 2011 00:15:02 +0900
Message-ID: <12728.1308237302@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Erez Zadok:
> (B) APPROACHES TO UNIONING
	:::
> My group, Juniro and his team, and I have spent a huge amount of time =

Oh, I have no team, no co-worker.


> over the years developing a standalone stackable file system based =
> approach.  These approaches were rejected largely due to their =
	:::
> location for this functionality.  There is some merit to a VFS based =
> approach: unioning performs a fair amount of namespace manipulation =
> (merging directories, eliminating duplications, whiteouts and opaques, =
> etc.), and the VFS is often best suited for complex namespace =
> operations.

Exactly.
I understand everybody likes simpler patch, and I have no objection to
merge UnionMount into mainline. But this union-type-mount approach has
some demerit which I have posted before. Those are inherited by
overlayfs too, and Miklos called it "unPOSIXy behavior". I think the
most part of the cause of these behaviour came from its design or
architecture. At the same time, that is one reason I chose
union-type-filesystem. In other words, there surely exists several
issues which are hard to implement if we don't adopt
union-type-filesystem (I never say it is impossible since someone else
may get a new idea someday).


> (C) ABOUT OVERLAYFS
>
> I've reviewed overlayfs's code.  I found it easy enough to follow that I =
> was able to fix a few bugs and add a feature or two.  It's small enough =
> to be easily reviewed.  I therefore argue that we should NOT try and add =
> a ton of features to overlayfs now, but rather review it as is, consider =
> merging it soon, and gradually add features over time (BTW, I just =

I agree that is one good way among several possible ways.
But I think those missing features or "unPOSIXy behavior" are important
and essentially necessary. For me, the current feature set of overlayfs
looks like aufs many years ago when I started thinking about
unioning. Aufs tried making those unPOSIXy behavior into correct
behaviour for years and it was satisfied in the middle of aufs1 era.
I don't know how next few years of overlayfs will be. It may be similar
to the history of aufs, or totally different one.
The priority of a feature to support direct-modification on a member is
not so high. The correct behaviour is most important I think.

Additionally the number of members may be important too. Overlayfs
supports only two members currently. When a user wants more layers,
he has to mount another overlayfs over overlayfs. Since it is
essentially equivalent to a recursive function call internally, and of
course the stack size in kernel space is limited, I don't think it is
good.

Also Miklos replied and said modifying the credentials internally does
no harm to other threads. But I am still afraid it a security hole since
the credentials is shared among threads. If I had time, I would test it
by myself.


J. R. Okajima
