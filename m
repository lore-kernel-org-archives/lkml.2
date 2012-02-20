Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2BTQKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:10:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53130 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2BTQKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:10:31 -0500
Message-ID: <1329754219.2293.357.camel@twins>
Subject: Re: [RFC PATCH 08/14] sched: normalize tg load contributions
 against runnable time
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 17:10:19 +0100
In-Reply-To: <CAPM31R+r0sjcFy2rTG1z2fOg=wTvfV35qZbSUHu89x=U3Os7yQ@mail.gmail.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013826.20844.39042.stgit@kitami.mtv.corp.google.com>
	 <1329348972.2293.189.camel@twins>
	 <CAPM31R+r0sjcFy2rTG1z2fOg=wTvfV35qZbSUHu89x=U3Os7yQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 04:32 -0800, Paul Turner wrote:
> > Neither the comment nor the changelog mention this, it should, it should
> > also mention why it doesn't matter (does it?).
> 
> It doesn't and it should.  Although I'll take the liberty shortening
> it a little to something

For the in-code comment that's fine, it would be good for the changelog
to have the entire story though.

>  like "unfortunately we cannot compute
> runnable_avg(tg) directly, however, XXX is a reasonable
> approximation." 

Yeah, not easily done indeed, you could compute a corrective term if
you'd have something like the avg and variance of runnable over the
various CPUs, but those too suck to have to compute.


