Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab0GWCMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 22:12:36 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47409 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab0GWCMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 22:12:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=JKBSCjkUSFsxGtW0ywzrnMcCCDyO46MvrQB/6C1e4PXJGDYasNkwA/et2yR7kMG2M
	+7OUJIOVqY8zc8XbC4QtQ==
MIME-Version: 1.0
In-Reply-To: <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	<20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	<AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
	<20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
Date: Thu, 22 Jul 2010 19:12:30 -0700
Message-ID: <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time accounting
From: Venkatesh Pallipadi <venki@google.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 4:12 AM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> On Tue, 20 Jul 2010 09:55:29 -0700
> Venkatesh Pallipadi <venki@google.com> wrote:
>
<snip>
>
>> Archs like s390/powerpc/ia64 already do this kind of accounting with
>> VIRT_CPU_ACCOUNTING. So, this patch will give them task and cgroup
>> level info free of charge (other than potential bugs with this code
>> change :-)).
>
> Well, the task and cgroup information is there but what does it really
> tell me? As long as the irq & softirq time can be caused by any other
> process I don't see the value of this incorrect data point.
>

Data point will be correct. How it gets used is a different qn. This
interface will be useful for Alert/Paranoid/Annoyed user/admin who
sees that the job exec_time is high but it is not doing any useful
work. With this additional info, he can probably choose to move the
job off to different system. User probably knows more about the job
characteristics and whether it is rightly or wrongly being charged.
Say one task in the task group being charged for another task in the
task group is probably OK as well. So, user can look at this in
different granularity than kernel can.

Thanks,
Venki
