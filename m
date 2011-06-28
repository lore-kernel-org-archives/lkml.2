Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab1F1KF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:05:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38150 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab1F1KC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:02:59 -0400
Subject: Re: [patch 15/16] sched: return unused runtime on voluntary sleep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <CAPM31RLtNnJqX00vTQ6PbUcGRhNufbvb1OdGkXs4i2+=4=A5eA@mail.gmail.com>
References: <20110621071649.862846205@google.com>
	 <20110621071701.165027089@google.com> <1308842778.1022.136.camel@twins>
	 <CAPM31RLtNnJqX00vTQ6PbUcGRhNufbvb1OdGkXs4i2+=4=A5eA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 28 Jun 2011 12:01:50 +0200
Message-ID: <1309255310.6701.186.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 18:42 -0700, Paul Turner wrote:

> - The aesthetics of releasing rq->lock in the put path.  Quick
> inspection suggests it should actually be safe to do at that point,
> and we do similar for idle_balance().
> 
> Given consideration the above two factors are not requirements, this
> could be moved out of a timer and into the put_path directly (with the
> fact that we drop rq->lock strongly commented).  I have no strong
> preference between either choice.

Argh, ok I see, distribute_cfs_runtime() wants that. Dropping rq->lock
is very fragile esp from the put path, you can only do that _before_ the
put path updates rq->curr etc.. So I'd rather you didn't, just keep the
timer crap and add some comments there.

And we need that distribute_cfs_runtime() muck because that's what
unthrottles rqs when more runtime is available.. bah.


