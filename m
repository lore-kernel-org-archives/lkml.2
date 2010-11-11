Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab0KKH5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 02:57:49 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37334 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757847Ab0KKH5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 02:57:47 -0500
Subject: Re: [linux-2.6.36-git7: Power7] LTP Memory CGROUP Controller
	functional test creates Backtrace, OOMKill & rcu_sched_state detected stall
	jiffies
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        ltp-list <ltp-list@lists.sf.net>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
In-Reply-To: <20101027094502.208c1207.kamezawa.hiroyu@jp.fujitsu.com>
References: <1288089237.5010.9.camel@subratamodak.linux.ibm.com>
	 <20101027094502.208c1207.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: IBM
Date: Thu, 11 Nov 2010 13:27:25 +0530
Message-Id: <1289462245.5622.46.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 09:45 +0900, KAMEZAWA Hiroyuki wrote: 
> On Tue, 26 Oct 2010 16:03:56 +0530
> Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
> 
> > If you run LTP Memory CGROUP Controller functional test on
> > linux-2.6.36-git7, the following Backtrace, OOMKill & rcu_sched_state
> > detected stall jiffies are created. The machine is not reachable
> > thereafter. Ways to reproduce this problem:
> > 
> > 1) Build and boot kernel 2.6.36-git7 on Power7 machine with attached
> > config file,
> > 2) Fetch, build and install LTP:
> > 	git clone git://ltp.git.sourceforge.net/gitroot/ltp/ltp
> > 	cd ltp
> > 	./configure
> > 	make
> > 	make install
> > 3) Create a LTP runtest file /opt/ltp/runtest/memcg_function_test with
> > the following entry:
> > memcg_function          memcg_function_test.sh
> > <<EOF>>
> > 	cd /opt/ltp
> > 	./runltp -f memcg_function_test
> > 
> 
> IIUC, memcg test includes intentional OOM-Kill test by setting the limit to 0.
> And it has another test to set the limit to PAGE_SIZE.
> 
> In your environemnt, I think page size is 64kb...right ?
> 
> About rcu_sched_state()....I have no idea at this stage. I reviewed memcontrol.c
> and oom_kill.c again and coundn't found anything in quick review.
> 
> Could you try again after -rc1 shipped ?

Oh Sure, I saw this mail now. I will try it out on the latest git tree
available :-)

Regards--
Subrata

> I think Andrew Morton sent some amount of updates for oom_kill and memcg, vmscan
> to Linus, today.
> 
> Thanks,
> -Kame
> 

