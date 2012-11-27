Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2K0QcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:32:05 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39990 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab2K0QbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:31:15 -0500
MIME-Version: 1.0
In-Reply-To: <20121127161639.GF2474@linux.vnet.ibm.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	<CAFTL4hydk-FT_hqCbcSPFcNCKnqxtWGz0VjTu3nNnQYfbtTz6Q@mail.gmail.com>
	<20121127161639.GF2474@linux.vnet.ibm.com>
Date: Tue, 27 Nov 2012 17:31:14 +0100
Message-ID: <CAFTL4hw5fgZccTMhV81OxVVfitUtqWXQi9djTCPJz7-4ff35Pg@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix abnormal rcu dynticks_nesting values related to
 async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, sasha.levin@oracle.com,
        gleb@redhat.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/27 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> It is OK to call rcu_irq_exit() without a matching rcu_irq_enter() -only-
> if you have also called rcu_idle_exit() since the last rcu_idle_enter().
> There will be a similar rule for rcu_user_exit().
>
> More generally, it is OK to call rcu_irq_exit() without a matching
> rcu_irq_enter() only if RCU believes that the CPU you are running on is
> non-idle.

Perfect!

>  On 32-bit systems, you are only allowed a few tens of million
> such unmatched rcu_irq_enter() calls in a given RCU-non-idle region.
>
> All courtesy of RCU's need to tolerate architectures that enter
> interrupt handlers without ever leaving them and vice versa.  ;-)

RCU idle mode in a hostile environment ;-)
