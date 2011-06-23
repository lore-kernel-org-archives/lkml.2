Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364Ab1FWMHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:07:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60644 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab1FWMHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:07:50 -0400
Subject: Re: [patch 00/16] CFS Bandwidth Control v7
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <4E01BE6B.2090701@jp.fujitsu.com>
References: <20110621071649.862846205@google.com>
	 <4E01BE6B.2090701@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 14:06:56 +0200
Message-ID: <1308830816.1022.112.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 19:05 +0900, Hidetoshi Seto wrote:
> I'll continue my test/benchmark on this v7 for a while.
> Though I believe no more bug is there, I'll let you know if there is
> something.

Would that testing include performance of a kernel without these patches
vs one with these patches in a configuration where the new feature is
compiled in but not used?

It does add a number of if (!cfs_rq->runtime_enabled) return branches
all over the place, some possibly inside a function call (depending on
what the auto-inliner does). So while the impact should be minimal, it
would be very good to test it is indeed so.


