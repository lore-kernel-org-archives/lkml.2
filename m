Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab1GZGAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:00:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36352 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1GZGAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:00:19 -0400
Subject: Re: [Patch] VFS : mount lock scalability for files systems without
 mount point   (WAS vfsmount lock issues on very large ppc64 box)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1311636178.2576.34.camel@schen9-DESK>
References: <20110717010427.GC5359@parisc-linux.org>
	 <20110717084630.GC8006@one.firstfloor.org>
	 <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110718154008.GA29593@infradead.org>
	 <20110718155141.GA11013@ZenIV.linux.org.uk>
	 <1311093158.2707.75.camel@schen9-DESK>
	 <20110721204042.GB31405@ZenIV.linux.org.uk>
	 <1311294452.2576.18.camel@schen9-DESK>
	 <20110723132411.GA22183@infradead.org>
	 <1311633550.2576.33.camel@schen9-DESK>
	 <20110725225154.GD22133@ZenIV.linux.org.uk>
	 <1311636178.2576.34.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 08:00:13 +0200
Message-ID: <1311660013.2996.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 25 juillet 2011 à 16:22 -0700, Tim Chen a écrit :
> On Mon, 2011-07-25 at 23:51 +0100, Al Viro wrote:
> 
> > It's mostly merged in mainline already...  BTW, you forgot to export
> > that sucker - mtdchar can be modular.
> 
> Thanks for fixing it up and merging it.
> 

Next step is to not chain pipes/sockets into superblock s_inodes list

inode_sb_list_add()/inode_sb_list_del() is the very last contention
point because of spin_lock(&inode_sb_list_lock);



