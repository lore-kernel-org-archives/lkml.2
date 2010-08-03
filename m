Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0HCIPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:15:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59441 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0HCIPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:15:12 -0400
To: Hui Zhu <teawater@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        gdb@sourceware.org
Subject: Re: [PATCH] kexec: set prstatus.pr_pid to cpu id when current->pid is  0
References: <AANLkTikuUi=i6Lk-ZpE65Gr0tWOeVnrnpWPe85T=J=Ph@mail.gmail.com>
	<m1zkx4w3hx.fsf@fess.ebiederm.org>
	<AANLkTi=-By6ZWjo9bW0s4MndFftHegROO7oa0jbpnCho@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 01:15:04 -0700
In-Reply-To: <AANLkTi=-By6ZWjo9bW0s4MndFftHegROO7oa0jbpnCho@mail.gmail.com> (Hui Zhu's message of "Tue\, 3 Aug 2010 15\:44\:35 +0800")
Message-ID: <m1d3u0un7b.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hui Zhu <teawater@gmail.com> writes:

> On Tue, Aug 3, 2010 at 15:37, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Hui Zhu <teawater@gmail.com> writes:
>>
>
> Equal 0 is not a bug, the trouble is a lot of core's pid is same.
>
> This is what gdb say:
> /* Found an old thread with the same id.  It has to be dead,
>        otherwise we wouldn't be adding a new thread with the same id.
>        The OS is reusing this id --- delete it, and recreate a new
>        one.  */

gdb bug compatibility is not a primary goal.  Having an extensible
format and not inventing it totally out of the blue is the goal.

The goal was always that something could post process the output of
the kernel crashdump and create something that is gdb compatible.  It
looks to me like it would take just a moment to strip out all of the
idle threads.

Claiming the pid is the cpu number when the pid is the idle pid gives
you no insulation against duplication, and it looses information.

Eric
