Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab0J0Auc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:50:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51676 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609Ab0J0Aub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:50:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Oct 2010 09:45:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: subrata@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        ltp-list <ltp-list@lists.sf.net>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [linux-2.6.36-git7: Power7] LTP Memory CGROUP Controller
 functional test creates Backtrace, OOMKill & rcu_sched_state detected stall
 jiffies
Message-Id: <20101027094502.208c1207.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1288089237.5010.9.camel@subratamodak.linux.ibm.com>
References: <1288089237.5010.9.camel@subratamodak.linux.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 16:03:56 +0530
Subrata Modak <subrata@linux.vnet.ibm.com> wrote:

> If you run LTP Memory CGROUP Controller functional test on
> linux-2.6.36-git7, the following Backtrace, OOMKill & rcu_sched_state
> detected stall jiffies are created. The machine is not reachable
> thereafter. Ways to reproduce this problem:
> 
> 1) Build and boot kernel 2.6.36-git7 on Power7 machine with attached
> config file,
> 2) Fetch, build and install LTP:
> 	git clone git://ltp.git.sourceforge.net/gitroot/ltp/ltp
> 	cd ltp
> 	./configure
> 	make
> 	make install
> 3) Create a LTP runtest file /opt/ltp/runtest/memcg_function_test with
> the following entry:
> memcg_function          memcg_function_test.sh
> <<EOF>>
> 	cd /opt/ltp
> 	./runltp -f memcg_function_test
> 

IIUC, memcg test includes intentional OOM-Kill test by setting the limit to 0.
And it has another test to set the limit to PAGE_SIZE.

In your environemnt, I think page size is 64kb...right ?

About rcu_sched_state()....I have no idea at this stage. I reviewed memcontrol.c
and oom_kill.c again and coundn't found anything in quick review.

Could you try again after -rc1 shipped ?
I think Andrew Morton sent some amount of updates for oom_kill and memcg, vmscan
to Linus, today.

Thanks,
-Kame

