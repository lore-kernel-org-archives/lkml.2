Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1DENa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:30:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab1DEN2c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:28:32 -0400
Subject: Re: [patch 01/15] sched: introduce primitives to account for CFS
 bandwidth tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110323030448.756701159@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030448.756701159@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Apr 2011 15:28:23 +0200
Message-ID: <1302010103.2225.1336.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
> +const u64 max_cfs_quota_period = 5 * NSEC_PER_SEC; /* 5s */

I would prefer that max to be _much_ lower than that, 5 seconds is a
long time to be throttled while holding a lock the rest of the system
wants.


