Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab1IJHdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 03:33:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab1IJHdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 03:33:42 -0400
Date: Sat, 10 Sep 2011 17:33:20 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pim Zandbergen <P.Zandbergen@macroscoop.nl>,
        Bruno Wolff III <bruno@wolff.to>,
        Wu Fengguang <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>
Subject: [PULL REQUEST] more md fixes for 3.1
Message-ID: <20110910173320.3e62bea0@notabene.brown>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus, 
 a few more little fixes for md for 3.1
 One is not in md code but is triggered by md.
 one is a minor fix needed to prepare for the next
 one fixed a bug introduced in 3.1
 last is a longer standing bug which is cc:ed to stable.

Thanks,
NeilBrown



The following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:

  Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)

are available in the git repository at:
  git://neil.brown.name/md for-linus

NeilBrown (4):
      Avoid dereferencing a 'request_queue' after last close.
      md/raid10: unify handling of write completion.
      md/raid1,10: Remove use-after-free bug in make_request.
      md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.

 drivers/md/md.c     |   12 ++++++++++--
 drivers/md/raid1.c  |   14 +++++++++-----
 drivers/md/raid10.c |   47 ++++++++++++++++++++++++-----------------------
 fs/block_dev.c      |    7 +++++--
 4 files changed, 48 insertions(+), 32 deletions(-)
