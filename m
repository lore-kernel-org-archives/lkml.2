Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0DLVBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:01:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41975 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0DLVBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RK6wl1auYnnvq8xza6X8y4IKH/CLEh1sgDxi4N73Z3dxBknqLT6WaUvcp1jPYUe4wL
         sCWJJ6BjSukIpUd/JUSFlSMFbkR4Bx2Kue7VBlaxmhp2fyvIXOPTrGulmQ2fsEWVI/Vy
         I6oLrurR4a9aMZRaokPYY40GMU4rK3MmBv1X4=
Date: Mon, 12 Apr 2010 23:01:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/5] ext2: Preparation to remove BKL
Message-ID: <20100412210127.GE8285@nowhere>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271104905-8804-1-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 10:41:40PM +0200, Jan Blunck wrote:
> In this series I've collected the patches that prepare ext2 for BKL removal.
> It consist mostly of cleanups and additionally introduces a spinlock to protect
> some of the superblock's fields against concurrent access. I've addressed the
> feedback kindly provided by Ogawa-san by moving the ext2_write_super() out of
> ext2_setup_super().
> 
> These patches have been part of the BKL removal series that I have posted in
> November 2009 already. Since this is more than just removing the usage of the
> big lock I repost it separately for inclusion. This series, at least the last
> patch that includes the s_lock, needs to be merged before Frederics bkl-removal
> branch, if he merges the rest of my patches there.


It looks like this is all about .35 material.

This is going to be hard to have a separate tree to pushdown/remove
the bkl in the mount path if it depends on the ext2 tree.

What about putting that with the fs bkl removal tree? Would that conflict
with other changes in the ext2 tree?

Thanks.

