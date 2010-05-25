Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845Ab0EYQBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:01:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758783Ab0EYQBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:01:53 -0400
Date: Wed, 26 May 2010 02:01:49 +1000
From: Nick Piggin <npiggin@suse.de>
To: Albert Herranz <albert_herranz@yahoo.es>,
       aya Kumar <jayakumar.lkml@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: page_mkwrite vs pte dirty race in fb_defio
Message-ID: <20100525160149.GE20853@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I couldn't find where this patch (49bbd815fd8) was discussed, so I'll
make my own thread. Adding a few lists to cc because it might be of
interest to driver and filesystem writers.

The old ->page_mkwrite calling convention was causing problems exactly
because of this race, and we solved it by allowing page_mkwrite to
return with the page locked, and the lock will be held until the
pte is marked dirty. See commit b827e496c893de0c0f142abfaeb8730a2fd6b37f.

I hope that should provide a more elegant solution to your problem. I
would really like you to take a look at that, because we already have
filesystem code (NFS) relying on it, and more code we have relying on
this synchronization, the more chance we would find a subtle problem
with it (also it should be just nicer).

Thanks,
Nick

