Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab0F3Sdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 14:33:40 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34831 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab0F3Sdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 14:33:39 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Latchesar Ionkov <lucho@ionkov.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
In-Reply-To: <AANLkTimmEi-3WF3pMcXmKiyElG9O7QLHNImPN0eJ05D3@mail.gmail.com>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com> <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org> <20100608004102.GQ31073@ZenIV.linux.org.uk> <87pqzrexon.fsf@linux.vnet.ibm.com> <871vbwe6lp.fsf@linux.vnet.ibm.com> <AANLkTiksmwITS6aCuXXZGR916OTEBm9VQ1MSzzEt8F7S@mail.gmail.com> <AANLkTikyqHtazndL_zBux7Zk0qZSJuNEvitHj8wkuSWW@mail.gmail.com> <87mxuc91r2.fsf@linux.vnet.ibm.com> <AANLkTimmEi-3WF3pMcXmKiyElG9O7QLHNImPN0eJ05D3@mail.gmail.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Thu, 01 Jul 2010 00:03:29 +0530
Message-ID: <87bpas8j5y.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010 12:16:15 -0600, Latchesar Ionkov <lucho@ionkov.net> wrote:
> I think that you need to use the s_vfs_rename_mutex in the super_block
> struct instead of introducing a new rename_lock in the v9fs session.
> 

I guess that will have lock dependency issue with inode->i_mutex. Also as Linus
suggested with dentry name copied we can avoid holding the lock when
doing 9P operation.
 
-aneesh
