Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab0DOGjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:39:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0DOGjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:39:06 -0400
Message-ID: <4BC6B4B3.8070000@cn.fujitsu.com>
Date: Thu, 15 Apr 2010 14:39:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, balbir@linux.vnet.ibm.com,
       lizf@cn.fujitsu.com, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Lockdep splat in cpuset code acquiring alloc_lock
References: <20100414202347.GA26791@linux.vnet.ibm.com> <z2m6599ad831004141410tdc40feb0h529dabe4a39d67d5@mail.gmail.com>
In-Reply-To: <z2m6599ad831004141410tdc40feb0h529dabe4a39d67d5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC Oleg
CC Ingo

on 2010-4-15 5:10, Paul Menage wrote:
> Looks like select_fallback_rq() shouldn't be calling
> cpuset_cpus_allowed_locked(), which does a task_lock(), which isn't
> IRQ safe. Also, according to its comments that should only be held
> with the cpuset callback_mutex held, which seems unlikely from a
> softirq handler.
> 
> Also, calling cpuset_cpus_allowed_locked(p, &p->cpus_allowed) stomps
> on state in p without (AFAICS) synchronization.
> 
> The description of commit e76bd8d9850c2296a7e8e24c9dce9b5e6b55fe2f
> includes the phrase " I'm fairly sure this works, but there might be a
> deadlock hiding" although I think that the lockdep-reported problem is
> different than what Rusty had in mind.

This problem have been fixed by Oleg Nesterov, and the patchset was merged
into tip tree, but it's scheduled for .35 ...

http://lkml.org/lkml/2010/3/15/73

Thanks!
Miao

