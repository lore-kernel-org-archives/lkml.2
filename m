Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966278Ab2EOSfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:35:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48080 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab2EOSfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:35:44 -0400
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <20120515153757.GF2461@linux.vnet.ibm.com>
References: <20120515044145.GA21910@redhat.com>
	<20120515144658.GC2461@linux.vnet.ibm.com>
	<CACLa4pt=Hh1=E9Jno_BAU-6stRL=hY3wehpWycKCYYJbJzYEGw@mail.gmail.com>
	<1923713.Kphzxkir2y@sifl>
	<20120515153757.GF2461@linux.vnet.ibm.com>
Date: Tue, 15 May 2012 14:35:43 -0400
Message-ID: <CAHC9VhTv_VfF+1CtczdjkGwVHk1Or-PD+KPdk0TsOqX8Kwr_6Q@mail.gmail.com>
Subject: Re: suspicious RCU usage in security/selinux/netnode.c
From: Paul Moore <paul@paul-moore.com>
To: paulmck@linux.vnet.ibm.com
Cc: Eric Paris <eparis@parisplace.org>, Dave Jones <davej@redhat.com>,
        sds@tycho.nsa.gov, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 11:37 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Here you go:
>
> o       rcu_dereference_check() is for code shared between readers and
>        writers, so that it might be protected by either rcu_read_lock()
>        or some lock.
>
> o       rcu_dereference_protected() is for code that is only used by
>        updaters and never by readers.  So rcu_dereference_protected()
>        is (slightly) lighter weight than rcu_dereference_check()
>        because it does not need to protect against concurrent
>        updates.

Perfect, thank you.  Looks like rcu_dereference_protected() is the
right choice here.  Patch coming tomorrow if not later today.

-- 
paul moore
www.paul-moore.com
