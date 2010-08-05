Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295Ab0HEUzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:55:04 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:44398 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933027Ab0HEUyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:54:55 -0400
Date: Thu, 5 Aug 2010 22:54:48 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org
Cc: Chris Mason <chris.mason@oracle.com>, josef@redhat.com,
        Valdis.Kletnieks@vt.edu,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, dm-devel@redhat.com
Subject: Performance impact of CONFIG_SCHED_MC? direct-io test case
Message-ID: <20100805205448.GB6318@comet.dominikbrodowski.net>
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


How large is the performance impact of CONFIG_SCHED_MC -- for which there
is a warning that it comes "at a cost of slightly increased overhead in
some places."? Well, for the test workload I've been working with lately,

dd if=<device> of=/dev/zero bs=8k count=100000 iflag=direct

where <device> is a dm-crypted LVM volume consisting of several
partitions on a notebook pata harddisk, and all this runs on a Core2 Duo,
I get a ~ 10 % performance reduction if CONFIG_SCHED_MC is enabled.

Combined with the CONFIG_DEBUG performance reduction mentioned in the other
message, all of the reduction from 28 MB/s to 18 MB/s is explained for.

Best,
	Dominik

PS: Ingo: you got both mingo@elte.hu and mingo@redhat.com in MAINTAINERS,
I suppose both are valid?
