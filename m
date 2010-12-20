Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0LTPko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:40:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180Ab0LTPkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:40:43 -0500
Message-ID: <4D0F78DF.9010908@redhat.com>
Date: Mon, 20 Dec 2010 10:40:15 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Mike Galbraith <mgalbraith@suse.de>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net>  <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net> <1292570143.7772.84.camel@marge.simson.net>
In-Reply-To: <1292570143.7772.84.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 02:15 AM, Mike Galbraith wrote:

> BTW, with this vruntime donation thingy, what prevents a task from
> forking off accomplices who do nothing but wait for a wakeup and
> yield_to(exploit)?
>
> Even swapping vruntimes in the same cfs_rq is dangerous as hell, because
> one party is going backward.

I just realized the answer to this question.

We only give cpu time to tasks that are runnable, but not
currently running.  That ensures one task cannot block others
from running by having time yielded to it constantly.
