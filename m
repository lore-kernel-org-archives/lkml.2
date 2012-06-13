Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab2FMDDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 23:03:01 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53929 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2FMDDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 23:03:00 -0400
From: Sadasivan Shaiju <sshaiju@mvista.com>
References: <20120612220924.GA13376@fifo99.com>	<20120612222912.GB16381@google.com>
	<20120612223422.GB13492@fifo99.com> <CACBanvo7DxYPWEtSAWV25Xq94vqJBugMAwbrEHz9DfSFTpSL_w@mail.gmail.com>
In-Reply-To: <CACBanvo7DxYPWEtSAWV25Xq94vqJBugMAwbrEHz9DfSFTpSL_w@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFrvVWGQb3OqXlfUmZ99ldVARdBggI9a19xAGTxnVwBxMbyTZeXbf1A
Date: Tue, 12 Jun 2012 20:02:58 -0700
Message-ID: <7275ce3e432566e843e207b1d3dbbe82@mail.gmail.com>
Subject: RE: hung_task checking and sys_sync
To: Mandeep Baines <msb@google.com>, Daniel Walker <dwalker@fifo99.com>
Cc: fweisbec@gmail.com, mingo@elte.hu, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There   was  another  patch   addressing  these  type  of  issue .

https://lkml.org/lkml/2009/1/12/18


regards,
shaiju.

-----Original Message-----
From: Mandeep Baines [mailto:msb@google.com]
Sent: Tuesday, June 12, 2012 3:45 PM
To: Daniel Walker
Cc: fweisbec@gmail.com; sshaiju@mvista.com; mingo@elte.hu;
akpm@linux-foundation.org; linux-kernel@vger.kernel.org
Subject: Re: hung_task checking and sys_sync

On Tue, Jun 12, 2012 at 3:34 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> On Tue, Jun 12, 2012 at 03:29:12PM -0700, Mandeep Singh Baines wrote:
>>
>> But the time is not unbounded. You could mask the hung_task_detector
>> for this case but then you lose the ability to catch bugs in this code
path.
>>
>> The timeout is configurable via
/proc/sys/kernel/hung_task_timeout_secs.
>> Can you bump up the value at boot via sysctl.conf?
>
> Maybe, but I'm wondering if these types should just be stopped because
> Andrew had complained about them already.
>

Fair enough. Actually, internally I had a patch where we'd use a task flag
to disable and enable the hang check but the approach in the patch you
pointed me to seems better.

>> > Has there been any commit that disable these messages bdi_sched_wait?
>> >
>>
>> No. There is no mechanism to disable hung_task for a specific code
path.
>> We do skip processes if PF_PROZEN or PF_FROZEN_SKIP is set but that
>> is really a different situation where the wait is unbounded.
>
> There is presidence for this type of change,
>
> Author: Mark Lord <kernel@teksavvy.com>
> Date:   Fri Sep 24 09:51:13 2010 -0400
>
>    block: Prevent hang_check firing during long I/O
>
>    During long I/O operations, the hang_check timer may fire,
>    trigger stack dumps that unnecessarily alarm the user.
>
>    Eg.  hdparm --security-erase NULL /dev/sdb  ## can take *hours* to
> complete
>
>    So, if hang_check is armed, we should wake up periodically
>    to prevent it from triggering.  This patch uses a wake-up interval
>    equal to half the hang_check timer period, which keeps overhead low
enough.
>
>    Signed-off-by: Mark Lord <mlord@pobox.com>
>    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
>

Interesting. I wasn't aware of this patch. Maybe we could abstract this
approach via wait_for_completion_no_hang_check().

Regards,
Mandeep
