Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab2EWLuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:50:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60653 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2EWLuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:50:13 -0400
Subject: Re: [PATCH 0/2] RFC: readd fair sleepers for server systems
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <4FBCCAE2.7080706@linux.vnet.ibm.com>
References: <1337615137-55111-1-git-send-email-schwidefsky@de.ibm.com>
	 <1337677268.9698.6.camel@twins>  <4FBCCAE2.7080706@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 13:49:58 +0200
Message-ID: <1337773798.27020.175.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 13:32 +0200, Christian Ehrhardt wrote:
> > Why is this, is this some weird interaction with your hypervisor?
> 
> It is not completely analyzed, as soon as debugging goes out of Linux it 
> can be kind of complex even internally. 

Is there significant steal time in these workloads? If so, does it help
if you implement
CONFIG_PARAVIRT_TIME_ACCOUNTING/paravirt_steal_rq_enabled for s390?
(although I guess we'd better loose the paravirt part of the name then).

This 'feature' subtracts steal time from the task-clock so that the
scheduler doesn't consider a task to be running when the vcpu wasn't
running as well.

Not doing that (current situation) could result in over-active
preemption because we think a task ran significantly longer than it
actually did. Same for sleeper fairness, we might think a task slept
very long (and give a bigger boost) when in fact it didn't.



