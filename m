Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab1ITOEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:04:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:58885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1ITOEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:04:51 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <peterz@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Date: Tue, 20 Sep 2011 16:04:33 +0200
References: <1315922848.5977.11.camel@twins>
	 <20110913162119.GA3045@linux.vnet.ibm.com> <1315931775.5977.29.camel@twins>
	 <20110913175425.GB3062@linux.vnet.ibm.com> <1315937995.4226.9.camel@twins>
	 <20110913182841.GO11100@linux.vnet.ibm.com>
	 <1315938646.4226.12.camel@twins>
	 <20110913183502.GP11100@linux.vnet.ibm.com>
	 <20110915175537.GA17701@linux.vnet.ibm.com>
	 <1316123323.4060.24.camel@twins>
	 <20110919175129.GA11164@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316527473.13664.33.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 15:56 +0200, Peter Zijlstra wrote:
> 
> Anyway, once enough random crap wakes up, the load-balancer goes shift
> stuff around, once we hit the group_imb conditions we seem to get stuck
> in a bad state instead of getting out of it. 

I bet all that crap wakes on the same tick that sets of the
load-balancer, because none of those things runs long enough to register
otherwise.

Looks like we need proper time weighted load averages for the regular lb
too.. pjt mentioned doing something like that as well, if only to reduce
the number of different load calculations we have.


