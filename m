Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab0F2BC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 21:02:27 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47964 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0F2BC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 21:02:26 -0400
Content-Type: text/plain; charset=UTF-8
Cc: Jesper Nilsson <jesper.nilsson@axis.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>, Ingo Molnar <mingo@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 39/40] trace syscalls: Clean confusing {s,r,}name and fix ABI breakage
From: Ian Munsie <imunsie@au1.ibm.com>
To: Jason Baron <jbaron@redhat.com>
In-reply-to: <20100623180353.GB2680@redhat.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-40-git-send-email-imunsie@au1.ibm.com> <20100623180353.GB2680@redhat.com>
Date: Tue, 29 Jun 2010 11:02:01 +1000
Message-Id: <1277770197-sup-4485@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Jason Baron's message of Thu Jun 24 04:03:54 +1000 2010:
> overall this patch is a major improvement! My question though is
> about the naming of the compat syscalls in the context of events. I
> believe this patch differeniates compat syscall event names as:
> "sys32_enter_sname", and "compat_sys_enter_sname". I agree that we keep that
> distinction for purposes of defining the actual syscall function. However,
> we had discuessed previously about keeping the event name the same for
> all compat syscalls. ie they are all called "compat_sys_sname" or some
> such. Reason being you could just do "compat_*" to match all compat
> events.


Sorry for the delay in replying - I've been pretty busy with other work
over the last few days.

I can certainly change that to name them all compat_sys to be more
consistent. In terms of activating all of them at once that can still be
done fairly easily since they are in their own compat_sys category with
something like "perf record -e 'compat_syscalls:*' ..." or "echo 1 >
/sys/kernel/debug/tracing/events/compat_syscalls/enable".

Ideally I would actually like to consolidate these events with the
ordinary syscall events and just print out compat=0|1 as part of their
output.

Since many of the native syscalls are used as compat syscalls as well I
think that would make a whole lot more sense - at the moment to catch
all syscalls from a compat process both the compat and native syscalls
would need to be activated.

It would also have the benefit of removing any arch specific naming from
userspace, which would make things a lot nicer.

Cheers,
-Ian
