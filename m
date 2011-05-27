Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1E0SVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:21:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62090 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1E0SVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:21:36 -0400
Date: Fri, 27 May 2011 11:21:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, linux-next@vger.kernel.org
Subject: Re: linux-next: Tree for May 27 (ocfs2)
Message-Id: <20110527112109.78501105.randy.dunlap@oracle.com>
In-Reply-To: <20110527093043.0840ac30.randy.dunlap@oracle.com>
References: <20110527155231.3a9925c0.sfr@canb.auug.org.au>
	<20110527093043.0840ac30.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DDFEBA1.0017:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011 09:30:43 -0700 Randy Dunlap wrote:

> On Fri, 27 May 2011 15:52:31 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110526:
> 
> ocfs2 on i386 has build errors:
> 
> ERROR: "__udivdi3" [fs/ocfs2/ocfs2.ko] undefined!
> ERROR: "__umoddi3" [fs/ocfs2/ocfs2.ko] undefined!
> 
> or when builtin:
> 
> fs/built-in.o: In function `ocfs2_find_victim_alloc_group.clone.0':
> move_extents.c:(.text+0x1fb01a): undefined reference to `__udivdi3'
> fs/built-in.o: In function `ocfs2_validate_and_adjust_move_goal':
> move_extents.c:(.text+0x1fb12e): undefined reference to `__umoddi3'
> move_extents.c:(.text+0x1fb15a): undefined reference to `__udivdi3'
> fs/built-in.o: In function `ocfs2_find_victim_alloc_group.clone.0':
> move_extents.c:(.text+0x1fb01a): undefined reference to `__udivdi3'
> fs/built-in.o: In function `ocfs2_validate_and_adjust_move_goal':
> move_extents.c:(.text+0x1fb12e): undefined reference to `__umoddi3'
> move_extents.c:(.text+0x1fb15a): undefined reference to `__udivdi3'
> fs/built-in.o: In function `ocfs2_find_victim_alloc_group.clone.0':
> move_extents.c:(.text+0x1fb01a): undefined reference to `__udivdi3'
> fs/built-in.o: In function `ocfs2_validate_and_adjust_move_goal':
> move_extents.c:(.text+0x1fb12e): undefined reference to `__umoddi3'
> move_extents.c:(.text+0x1fb15a): undefined reference to `__udivdi3'

Fixed by just-merged mainline commit:

Gitweb:     http://git.kernel.org/linus/6aea6f5068cb86e89a6ac243c3fc131045b6563a
Commit:     6aea6f5068cb86e89a6ac243c3fc131045b6563a
Parent:     dda54e76d7dba0532ebdd72e0b4f492a03f83225
Author:     Tristan Ye <tristan.ye@oracle.com>
AuthorDate: Fri May 27 15:19:56 2011 +0800
Committer:  Tristan Ye <tristan.ye@oracle.com>
CommitDate: Fri May 27 14:52:53 2011 +0800

    Ocfs2/move_extents: Avoid doing division in extent moving.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
