Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab2FAVDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 17:03:51 -0400
Received: from relay3.sgi.com ([192.48.152.1]:39188 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753667Ab2FAVDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 17:03:50 -0400
Date: Fri, 1 Jun 2012 16:03:48 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: relax_domain_level boot parameter has no effect
Message-ID: <20120601210348.GA22471@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed (and verified) that the relax_domain_level boot parameter does not
get processed because sched_domain_level_max is 0 at the time that
setup_relax_domain_level() is run.

int sched_domain_level_max;

static int __init setup_relax_domain_level(char *str)
{
        unsigned long val;

        val = simple_strtoul(str, NULL, 0);
        if (val < sched_domain_level_max)
                default_relax_domain_level = val;

        return 1;
}
__setup("relax_domain_level=", setup_relax_domain_level);


struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
..
                sched_domain_level_max = max(sched_domain_level_max, sd->level);
..
