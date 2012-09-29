Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab2I2MZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 08:25:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42205 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2I2MZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 08:25:06 -0400
MIME-Version: 1.0
In-Reply-To: <50669952.1000805@gmail.com>
References: <50659D37.2020206@gmail.com>
	<20120928133633.GC12843@somewhere.redhat.com>
	<20120928173133.GB2498@linux.vnet.ibm.com>
	<50669952.1000805@gmail.com>
Date: Sat, 29 Sep 2012 14:25:04 +0200
Message-ID: <CAFTL4hzuh+iXPpKpyHWvpx3-Dwy9aq+poJLF_u=xcVfJPiaQVw@mail.gmail.com>
Subject: Re: rcu: eqs related warnings in linux-next
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/29 Sasha Levin <levinsasha928@gmail.com>:
> Maybe I could help here a bit.
>
> lappy linux # addr2line -i -e vmlinux ffffffff8111d45f
> /usr/src/linux/kernel/timer.c:549
> /usr/src/linux/include/linux/jump_label.h:101
> /usr/src/linux/include/trace/events/timer.h:44
> /usr/src/linux/kernel/timer.c:601
> /usr/src/linux/kernel/timer.c:734
> /usr/src/linux/kernel/timer.c:886
>
> Which means that it was about to:
>
>         debug_object_activate(timer, &timer_debug_descr);

I can't find anything in the debug object code that might fault.
I was suspecting some per cpu allocated memory: per cpu allocation
sometimes use vmalloc
which uses lazy paging using faults. But I can't find such thing there.

May be there is some faulting specific to KVM...
