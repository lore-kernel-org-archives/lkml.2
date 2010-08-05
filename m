Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934190Ab0HEUzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:55:00 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:44385 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932975Ab0HEUyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:54:55 -0400
Date: Thu, 5 Aug 2010 22:47:49 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org
Cc: Chris Mason <chris.mason@oracle.com>, josef@redhat.com,
        Valdis.Kletnieks@vt.edu,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, dm-devel@redhat.com
Subject: Performance impact of CONFIG_DEBUG? direct-io test case
Message-ID: <20100805204749.GA6318@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org, mingo@redhat.com,
	peterz@infradead.org, Chris Mason <chris.mason@oracle.com>,
	josef@redhat.com, Valdis.Kletnieks@vt.edu,
	Michael Monnerie <michael.monnerie@is.it-management.at>,
	Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	xfs@oss.sgi.com, dm-devel@redhat.com
References: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
 <20100805113240.GA29846@think>
 <20100805153519.GA7242@comet.dominikbrodowski.net>
 <20100805163519.GA6604@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805163519.GA6604@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


How large is the performance impact of CONFIG_DEBUG? Well, for the test
workload I've been working with lately,

dd if=<device> of=/dev/zero bs=8k count=100000 iflag=direct

where <device> is a dm-crypted LVM volume consisting of several
partitions on a notebook pata harddisk, I get the following results:

1) best results are ~ 28 MB/s

2) Enabling CONFIG_DEBUG_LOCK_ALLOC, which also means CONFIG_LOCKDEP
   being enabled, causes the transfer rate to decrease by ~ 1.2 MB/s

3) Enabling CONFIG_DEBUG_SPINLOCK && CONFIG_DEBUG_MUTEXTES or
   CONFIG_DEBUG_SPINLOCK_SLEEP=y costs about ~ 0.4 MB/s each

4) Enabling all of the following options:
	CONFIG_DEBUG_RT_MUTEXES
	CONFIG_DEBUG_PI_LIST
	CONFIG_PROVE_LOCKING
	CONFIG_LOCK_STAT
	CONFIG_DEBUG_LOCKDEP
   costs another ~ 5 MB/s.

So, for this test case, the performance impact of (some) CONFIG_DEBUG
options is highly significant, here by about 25 %.

Best,
	Dominik
