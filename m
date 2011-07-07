Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1GGSQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:16:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab1GGSP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:15:58 -0400
Date: Thu, 7 Jul 2011 14:15:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
Message-ID: <20110707181535.GD2536@redhat.com>
References: <20110707053036.173186930@google.com>
 <20110707112302.GB8227@elte.hu>
 <1310049528.3282.583.camel@twins>
 <20110707145159.GD19193@elte.hu>
 <1310050482.3282.584.camel@twins>
 <20110707145620.GF19193@elte.hu>
 <20110707162344.GB2536@redhat.com>
 <1310059220.3282.591.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310059220.3282.591.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 07:20:20PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-07 at 12:23 -0400, Jason Baron wrote:
> 
> > yes, this is the type of case jump labels is designed for. Let me know
> > if there are any usage questions/concerns.
> 
> Unrelated to this change, I was looking at a case where it would be nice
> to have a way to specify the initial state of jump labels.
> 
> That is, currently:
> 
> jump_label_key foo;
> 
>   if (static_branch(&foo))
> 
> will default to false, until jump_label_inc(&foo) etc..
> 
> I was looking to add something like:
> 
> jump_label_key foo = JUMP_LABEL_TRUE;
> 
> Which would initialize the thing to be true, the problem with that is
> that it takes until the loop in jump_label_init() before that takes
> effect, which was too late in my particular case.
> 

We don't have to wait until jump_label_init() to make it take effect.

We could introduce something like: static_branch_default_false(&foo),
and static_branch_default_true(&foo), which are set at compile time. I
was waiting for a real world example before introducing it, but if this
would solve your issue,  we can look at it.

-Jason

