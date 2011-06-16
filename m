Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1FPPB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:01:59 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:47849 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1FPPB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:01:56 -0400
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
 Vpid:)
From: Greg Kurz <gkurz@fr.ibm.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, containers@lists.osdl.org,
        akpm@linux-foundation.org, xemul@openvz.org
In-Reply-To: <20110616132551.GB7230@hawkmoon.kerlabs.com>
References: <20110615145527.4016.70157.stgit@bahia.local>
	 <20110615184625.GA15573@redhat.com> <1308222107.8230.49.camel@bahia.local>
	 <20110616123554.GA7230@hawkmoon.kerlabs.com>
	 <1308229251.8230.77.camel@bahia.local>
	 <20110616132551.GB7230@hawkmoon.kerlabs.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 17:01:39 +0200
Message-ID: <1308236499.8230.89.camel@bahia.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 15:25 +0200, Louis Rilling wrote:
> > Ok. You're right, the RCU grace period is just what I need to ensure
> I
> > won't dereference a stale pointer. So I don't even have to bother
> with
> > ->siglock and just check pid_alive() before peeking into
> pid->numbers.
> 
> It ends like open-coding an optimized version of task_pid_vnr(). If
> the
> optimization is really important (I guess this depends on the depth of
> recursive
> pid namespaces), it would be better to re-write task_pid_vnr().
> Otherwise, just
> use task_pid_vnr() as it is.
> 
> Thanks,
> 
> Louis
> 
Hmm, sorry Louis but I'm looking for the pid number from the task active
pid_ns (AKA. the return value of getpid() if called by this task), so
task_pid_vnr() doesn't fit.

About the open-coding argument, that's why I used task_pid_nr_ns() and
task_active_pid_ns() at first...

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

