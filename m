Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab1CYMPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:15:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61021 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1CYMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Lc6MIQpEjmHMFYHsMm7Ent0lYZ1IXheTTgwXnRN07f7Xtd+hXY4mR1PG7Em1o8OtXT
         PWpzA354cPdMqaoRZ3rxKqa3vZRAa2thcwJbCitww4XDGTqLxAJTh0wln1uJsKwxbjIp
         FdJaXTfLVW7ju/tgHVesImr6ATvNv4hyKwSm8=
MIME-Version: 1.0
Date: Fri, 25 Mar 2011 20:15:34 +0800
Message-ID: <AANLkTinCk35LSMLyO0nD+Z1ZmZskaCCN5c8kyxLcmXYx@mail.gmail.com>
Subject: deadlock caused by printk
From: Ming Lei <tom.leiming@gmail.com>
To: torvalds@osdl.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These days I was studying "perf code" and try to dump some debug
info in event_sched_out(): kernel/perf_event.c by printk, but found
system can hang easily.

After digging into related code for several days, I find the hang is
caused by spinlock deadlock when acquiring rq->lock in task_rq_lock(),
which is called in the path below:

          try_to_wake_up<-wake_up_process<-up<-console_unlock<-printk.

I wonder if there are some usage conventions about printk, which says
explicitly that printk can not by used in some places of kernel. Or does the
above show that it is a bug of kernel?

If the above is really a limitation of printk, have we other dump functions
which may be used safely in some places of kernel source code where
printk is not allowed.

thanks,
-- 
Lei Ming
