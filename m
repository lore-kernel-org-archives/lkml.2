Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1HOM0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 08:26:07 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:36976 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709Ab1HOM0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 08:26:06 -0400
Subject: fs: why is lru_lock cachline_aligned_in_smp in the middle of
 super_block?
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Dave Chinner <dchinner@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Date: Mon, 15 Aug 2011 13:26:03 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313411164.1954.18.camel@castor.rsk>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 09cc9fc7a7c3d872065426d7fb0f0ad6d3eb90fc lru_lock was added to
super_block defined as :-

spinlock_t	s_inode_lru_lock ____cacheline_aligned_in_smp;

Due unfortunate placement in my 64 bit config, gcc has to add a lot of
padding to super_block to honour this.
I get 60 bytes before lru_lock & 32 bytes at the end of the structure.

So I was wondering what access pattern are you trying to avoid ?
And could it be prevented by just moving lru_lock and friends to
somewhere else in the structure? 

Even if they were at the end and still cacheline aligned then we would
not have that nearly empty cacheline in the middle.

If they are in the best place then at least add a comment to explain why
this needs to be cacheline aligned?

regards
Richard

 



