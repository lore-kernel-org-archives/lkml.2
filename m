Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab1IICXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:23:25 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:43223 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab1IICXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <4e5eb4e321047bd8bd@agluck-desktop.sc.intel.com>
References: <4e5eb3f12101199595@agluck-desktop.sc.intel.com>
	<4e5eb4e321047bd8bd@agluck-desktop.sc.intel.com>
Date: Fri, 9 Sep 2011 10:23:21 +0800
Message-ID: <CAC=cRTNSR+DiZiCLZUwksb7drYLgMw=reHjLuax8i8WFVp_Mag@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86, mce: rework use of TIF_MCE_NOTIFY
From: huang ying <huang.ying.caritas@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 6:25 AM, Luck, Tony <tony.luck@intel.com> wrote:
> From:   "Luck, Tony" <tony.luck@intel.com>
>
> From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>
> The basic flow of MCE handler is summarized as follows:
>  1) from NMI context:
>        check hardware error registers, determine error severity,
>        and then panic or request non-NMI context by irq_work() to
>        continue the system.
>  2) from (irq) context:
>        call non-NMI safe functions,
>        wake up loggers and schedule work if required
>  3) from worker thread:
>        process some time-consuming works like memory poisoning.
>
> TIF_MCE_NOTIFY flag is relatively legacy and have used to do tasks of
> 2) and 3) on the thread context that interrupted by MCE.  However now
> use of irq_work() and work-queue is enough for these tasks, so this
> patch removes duplicated tasks in mce_notify_process().

Sorry for late.

Why do you think work-queue is enough for these tasks?  Work-queue
thread may have low priority.  But the hardware error should be
processed as soon as possible for better error containment.  So I
think it is still a good idea to process error before returning to
user space.  That likes scheduling to the work directly before
returning to user space.  We can use "return to user notifier" to
implement this.

Best Regards,
Huang Ying
