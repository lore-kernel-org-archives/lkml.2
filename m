Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1F1JNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 05:13:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:34124 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab1F1JNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 05:13:06 -0400
Subject: Re: [patch 09/16] sched: unthrottle cfs_rq(s) who ran out of quota
 at period refresh
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <CAPM31RLbngLP-EuK6TwRCh11RHJMsh1+5vBNisVEvupkJ4q4ng@mail.gmail.com>
References: <20110621071649.862846205@google.com>
	 <20110621071700.599897751@google.com> <1308763751.1022.60.camel@twins>
	 <CAPM31RLbngLP-EuK6TwRCh11RHJMsh1+5vBNisVEvupkJ4q4ng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 28 Jun 2011 11:11:53 +0200
Message-ID: <1309252313.6701.177.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 21:40 -0700, Paul Turner wrote:
> >> +       if (unlikely(runtime_expires != cfs_b->runtime_expires))
> >> +               goto out_unlock;
> >
> > it might help to explain how, runtime_expires is taken from cfs_b after
> > calling __refill_cfs_bandwidth_runtime, and we're in the replenishment
> > timer, so nobody is going to be adding new runtime.
> >
> 
> Good idea -- thanks 

Aside from being a good idea, I'm genuinely puzzled by that part and
would love having it explained :-)
