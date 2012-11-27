Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2K0Qig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:38:36 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43771 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab2K0Qie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:38:34 -0500
Date: Tue, 27 Nov 2012 08:19:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, sasha.levin@oracle.com,
        avi@redhat.com
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
Message-ID: <20121127161925.GG2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hzzumANj7hF5hJPZ5pKPhz4YWC-Ukb3yUKdy_DO+vb3wg@mail.gmail.com>
 <20121127154455.GK12969@redhat.com>
 <CAFTL4hyfCt2imzBYW+Sn5QUAwham=ZQ2nNER5Np7Hq4yg1LzxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hyfCt2imzBYW+Sn5QUAwham=ZQ2nNER5Np7Hq4yg1LzxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112716-5806-0000-0000-00001C384E65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 04:56:30PM +0100, Frederic Weisbecker wrote:
> 2012/11/27 Gleb Natapov <gleb@redhat.com>:
> > For KVM_PV_REASON_PAGE_NOT_PRESENT it behaves like an exception.
> 
> Ok.
> There seem to be a bug in kvm_async_pf_task_wait(). Using
> idle_cpu(cpu) to find out if the current task is the idle task may not
> work if there is pending wake up. Me may schedule another task but
> when that other task sleeps later we can't schedule back to idle until
> the fault is completed.
> 
> The right way is to use is_idle_task(current)

Agreed.  But if you instead need to figure out whether or not RCU believes
that the CPU is idle, use rcu_is_cpu_idle().  You need to figure out
whether or not RCU believes that the CPU is idle if you are trying to
play fast and loose with rcu_irq_enter() and rcu_irq_exit().

							Thanx, Paul

