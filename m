Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0KJQBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:01:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab0KJQBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:01:42 -0500
Date: Wed, 10 Nov 2010 16:55:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: INFO: suspicious rcu_dereference_check() usage -
	kernel/pid.c:419 invoked rcu_dereference_check() without protection!
Message-ID: <20101110155530.GA1905@redhat.com>
References: <xr93fwwbdh1d.fsf@ninji.mtv.corp.google.com> <20101107182028.GZ15561@linux.vnet.ibm.com> <20101108151509.GA3702@redhat.com> <20101109202900.GV4032@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109202900.GV4032@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Paul E. McKenney wrote:
>
> Thank you, Oleg!  Greg, would you be willing to update your patch
> to remove the comment?  (Perhaps tasklist_lock as well...)

Agreed, I think tasklock should be killed.


But wait. Whatever we do, isn't this code racy? I do not see why, say,
sys_ioprio_set(IOPRIO_WHO_PROCESS) can't install ->io_context after
this task has already passed exit_io_context().

Jens, am I missed something?

Oleg.

