Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab1EQP3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:29:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab1EQP3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:29:00 -0400
Subject: Re: [patch 06/15] sched: accumulate per-cfs_rq cpu usage and
 charge against bandwidth
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
In-Reply-To: <BANLkTin_0v7q1xDwwnOpo6ZFMbDNARisGg@mail.gmail.com>
References: <20110503092846.022272244@google.com>
	 <20110503092904.985285812@google.com> <1305541621.2466.4112.camel@twins>
	 <BANLkTin_0v7q1xDwwnOpo6ZFMbDNARisGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 May 2011 17:28:42 +0200
Message-ID: <1305646122.2466.5894.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 05:59 -0700, Paul Turner wrote:
> On Mon, May 16, 2011 at 3:27 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
> >> +unsigned int sysctl_sched_cfs_bandwidth_slice = 5000UL;
> >
> > What happens when the period is smaller than the slice?
> >
> 
> We'll always take at most whatever's left in this case.

Right, saw that, but it might be good to have a little comment
explaining the interaction between the slice and the period things.
