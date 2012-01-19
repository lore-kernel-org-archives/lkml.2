Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab2ASVGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 16:06:12 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36179 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab2ASVGK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 16:06:10 -0500
MIME-Version: 1.0
In-Reply-To: <1326991117.17534.132.camel@gandalf.stny.rr.com>
References: <CAONaPpFjfGiKKGAzrQNk+MF4k50nRf+wMU8H9491NgHyJrUkyw@mail.gmail.com>
	<201201180053.52617.fzuuzf@googlemail.com>
	<1326848525.17534.66.camel@gandalf.stny.rr.com>
	<CAONaPpGHULxDZXBTprkCy9vKPH46gHOiQs6GM_ysfP2znDqqXg@mail.gmail.com>
	<1326991117.17534.132.camel@gandalf.stny.rr.com>
Date: Thu, 19 Jan 2012 22:06:09 +0100
X-Google-Sender-Auth: Iez1A-lKIpM9Nh9hkOZ2OgWy8vw
Message-ID: <CAONaPpHJM1GKdRCdvw97AsBSRQk1oHUt6u2bGJRoin+e59Wbzg@mail.gmail.com>
Subject: Re: rt-kernel 3.0.14-rt31: BUG: sleeping function called from invalid context
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Karsten Wiese <fzuuzf@googlemail.com>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 5:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2012-01-19 at 17:16 +0100, John Kacur wrote:
>
>> I'm testing v3.0.14-rt32-rc1, and it greatly reduced the number of
>> these, but I still got one during boot.
>>
>> [   11.938649] BUG: sleeping function called from invalid context at
>> /home/jkacur/rt.linux.git/kernel/rtmutex.c:645
>> [   11.938651] in_atomic(): 1, irqs_disabled(): 1, pid: 168, name: irq/9-acpi
>> [   11.938653] 1 lock held by irq/9-acpi/168:
>> [   11.938653]  #0:  (acpi_gbl_gpe_lock){......}, at:
>> [<ffffffff8123881d>] acpi_ev_gpe_detect+0x31/0x110
>
> Could you test 3.2-rt. If that has the issue then we know we have more
> to fix. If not, we know I missed a patch.
>

I tested with v3.2-rt10 and the issue is not there.

I also examined your patches and couldn't find anything wrong with
them, and for larks tried applying
cpumask-disable-offstack-on-rt.patch from v3.2-rt10
all to no avail, the problem is still there.

Thanks
John
