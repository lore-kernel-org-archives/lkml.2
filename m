Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab0EDVGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 17:06:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39139 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab0EDVGJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 17:06:09 -0400
MIME-Version: 1.0
In-Reply-To: <87mxwf533b.fsf@basil.nowhere.org>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <1272667021-21312-2-git-send-email-arve@android.com>
	 <1272667021-21312-3-git-send-email-arve@android.com>
	 <1272667021-21312-4-git-send-email-arve@android.com>
	 <1272667021-21312-5-git-send-email-arve@android.com>
	 <87mxwf533b.fsf@basil.nowhere.org>
Date: Tue, 4 May 2010 14:06:07 -0700
Message-ID: <y2jd6200be21005041406j8f632e90l60941174b4f23c71@mail.gmail.com>
Subject: Re: [PATCH 4/8] PM: suspend_block: Add debugfs file
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Andi Kleen <andi@halobates.de>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Oleg Nesterov <oleg@redhat.com>,
       Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/4 Andi Kleen <andi@halobates.de>:
> Arve Hjønnevåg <arve@android.com> writes:
>>
>> +static int suspend_blocker_stats_show(struct seq_file *m, void *unused)
>> +{
>> +     unsigned long irqflags;
>> +     struct suspend_blocker *blocker;
>> +
>> +     seq_puts(m, "name\tactive\n");
>> +     spin_lock_irqsave(&list_lock, irqflags);
>> +     list_for_each_entry(blocker, &inactive_blockers, link)
>> +             seq_printf(m, "\"%s\"\t0\n", blocker->name);
>> +     list_for_each_entry(blocker, &active_blockers, link)
>> +             seq_printf(m, "\"%s\"\t1\n", blocker->name);
>> +     spin_unlock_irqrestore(&list_lock, irqflags);
>
> Could you report the pid here too?
>

Most of the suspend blockers are in the kernel, and does not have a pid.

> The name set by the application might be meaningless or duplicated.
>

Currently all the names set by android user-space are unique but the
pids are not. We can add columns, or extend the name of user space
suspend blockers in the ioctl interface, later if needed.

-- 
Arve Hjønnevåg
