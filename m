Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab0G3EqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:46:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28536 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab0G3EqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:46:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=quqWIlYCOaa8SM6iGdkxH3WryUfPTfKI3yCqc0qI96SrnUB68geMYjD+HMR0r1z/+
	qUKaAzfgxV0kgoZA6Xbaw==
MIME-Version: 1.0
In-Reply-To: <20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTing_3HoC9oWNheHJPgQWp2xmN6-C_cyZxoJUqc_@mail.gmail.com>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 29 Jul 2010 21:46:10 -0700
Message-ID: <AANLkTimvZSFHCZZ=SCQF8DtZ3vVYJmA=4qWs2SDAgvKi@mail.gmail.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
From: Hugh Dickins <hughd@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 9:14 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I'll prepare a routine not-quick-fix.

Thank you!

> BTW, after reading mail between you and Andrea, kernel threads are not guaranteed
> to be stopped when memory-dump is running ?

Depends on what you mean by memory-dump, I think.

The hibernation sequence is quite confusing to follow, but Rafael can
correct me if I'm wrong.  create_image() in kernel/power/snapshot.c
does disable_nonboot_cpus() and local_irq_disable() and
sysdev_suspend() and save_processor_state() and dives into
swsusp_arch_suspend() to create the image in memory with everything
else stopped; and it's from there that the system will later resume.
But it also emerges from there in the parallel universe that goes on
to allocate swap and copy the memory image to disk - at that time,
you'll not be surprised to learn that interrupts are enabled, and I
suppose other threads may be running, in a rather futile way.

Hugh
