Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2KFPU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:20:28 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46819 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2KFPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:20:24 -0500
MIME-Version: 1.0
In-Reply-To: <1352207399-29497-2-git-send-email-alex.shi@intel.com>
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
	<1352207399-29497-2-git-send-email-alex.shi@intel.com>
Date: Tue, 6 Nov 2012 10:20:23 -0500
Message-ID: <CAJRGBZzPcCGAz1nc_rGpVd5rq2sZiFZ0Gu_PVnsEzhkaUd7zFA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] sched: add sched_policy and it's sysfs interface
From: Luming Yu <luming.yu@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 8:09 AM, Alex Shi <alex.shi@intel.com> wrote:
> This patch add the power aware scheduler knob into sysfs:

The problem is user doesn't know how to use this knob.

Based on what data, people could select one policy which could be surely
better than another?

"Packing small tasks" approach could be better and more intelligent.
http://thread.gmane.org/gmane.linux.kernel/1348522

Just some random thoughts, as I didn't have chance to look into the
details of that patch set yet. But to me, we need to exploit the fact
that we could automatically bind a group of tasks on minimal set of
CPUs that can provide sufficient CPU cycles that are comparable to
a"cpu- run-average" that the task group can get in pure CFS situation
in a given period, until we see more CPU is needed.Then we probably
can maintain required CPU power available to the corresponding
workload, while leaving all other CPUs into power saving mode. The
problem is historical data suggested pattern could become invalid in
future, then we need more CPUs in future..I think this is the point we
need to know before spread or not-spread decision ...if spread would
not help CPU-run-average ,we don't need waste CPU power..but I don't
know how hard it could be. But I'm pretty sure sysfs knob is harder.
:-) /l
