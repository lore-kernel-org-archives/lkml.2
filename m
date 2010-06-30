Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab0F3Sbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:31:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575Ab0F3Sbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:31:47 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimmEi-3WF3pMcXmKiyElG9O7QLHNImPN0eJ05D3@mail.gmail.com>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com>
	<alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org>
	<20100608004102.GQ31073@ZenIV.linux.org.uk>
	<87pqzrexon.fsf@linux.vnet.ibm.com>
	<871vbwe6lp.fsf@linux.vnet.ibm.com>
	<AANLkTiksmwITS6aCuXXZGR916OTEBm9VQ1MSzzEt8F7S@mail.gmail.com>
	<AANLkTikyqHtazndL_zBux7Zk0qZSJuNEvitHj8wkuSWW@mail.gmail.com>
	<87mxuc91r2.fsf@linux.vnet.ibm.com>
	<AANLkTimmEi-3WF3pMcXmKiyElG9O7QLHNImPN0eJ05D3@mail.gmail.com>
Date: Wed, 30 Jun 2010 11:31:38 -0700
Message-ID: <AANLkTinVdrY7AHFCjDIWAD0yLGhLYZwwHH3kKXBlkD5v@mail.gmail.com>
Subject: Re: [V9fs-developer] [GIT PULL] 9p file system bug fixes for 
	2.6.35-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Latchesar Ionkov <lucho@ionkov.net>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 11:16 AM, Latchesar Ionkov <lucho@ionkov.net> wrote:
>
> I think that you need to use the s_vfs_rename_mutex in the super_block
> struct instead of introducing a new rename_lock in the v9fs session.

I actually think it's better to avoid having filesystems muck around
with VFS locking details. Also, I think we get the VFS rename mutex
only for cross-directory renames, and as mentioned, 9p needs locking
even for regular directory renames.

(Also, this way you can have parallel readers - although we could
obviously change the vfs rename mutex into a rw-sem too).

So I do think that keeping the logic private to a 9p-specific lock is
the right solution here.

                 Linus
