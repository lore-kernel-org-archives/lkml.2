Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab1BYIzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:55:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:39631 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab1BYIzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:55:09 -0500
Subject: Re: [CFS Bandwidth Control v4 5/7] sched: add exports tracking cfs
 bandwidth control statistics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <AANLkTinqp_gfhoLGe0_ShbahzHBLeMZoho46_aMAe17k@mail.gmail.com>
References: <20110216031831.571628191@google.com>
	 <20110216031841.258879435@google.com> <1298467932.2217.763.camel@twins>
	 <AANLkTinqp_gfhoLGe0_ShbahzHBLeMZoho46_aMAe17k@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Feb 2011 09:54:24 +0100
Message-ID: <1298624064.2428.1311.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 19:26 -0800, Paul Turner wrote:
> On Wed, Feb 23, 2011 at 5:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:
> >> +       raw_spin_lock(&cfs_b->lock);
> >> +       cfs_b->throttled_time += (rq->clock - cfs_rq->throttled_timestamp);
> >> +       raw_spin_unlock(&cfs_b->lock);
> >
> > That seems to put the cost of things on the wrong side. Read is rare,
> > update is frequent, and you made the frequent thing the most expensive
> > one.
> 
> Hum.. the trade-off here is non-trivial I think
> 
> - This update is only once per-quota period (*if* we throttled within
> that period).  This places the frequency in the 10s-100s of ms range.
> - Sampling would probably occur on an order of once a second (assuming
> some enterprise management system that cares about these statistics).

Ugh,. people are really polling state like that? If the event is rare
pushing state is much saner.
