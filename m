Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0F2IpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:45:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab0F2IpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Jgnf4GV38YbLZxn0u5JGQcXS1I0hRayXxuo2zHNYbgMijlPElDAxFbCDSsqcGiQZYZ
         k3M4HrKvOWVUXwD/BGuJ6fD0p5VCvsPoc+bb8Lc3ejyeYIU7qVJbMna2FQ8zSHpAwAGW
         LF47htQoTd25GDT0yLx65YCUij/noYiwOB6XY=
MIME-Version: 1.0
In-Reply-To: <20100628210342.GW4175@outflux.net>
References: <20100623181129.GM5876@outflux.net>
	<20100623194145.GA19628@redhat.com>
	<20100623202335.GA4424@x200>
	<20100628130028.73757a46.akpm@linux-foundation.org>
	<20100628210342.GW4175@outflux.net>
Date: Tue, 29 Jun 2010 11:45:14 +0300
Message-ID: <AANLkTinlrnSEwnWn_qcvdfqXM6b_bA3hbBjBrqgpQnKX@mail.gmail.com>
Subject: Re: [PATCH] sanitize task->comm to avoid leaking escape codes
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 12:03 AM, Kees Cook <kees.cook@canonical.com> wrote:
> On Mon, Jun 28, 2010 at 01:00:28PM -0700, Andrew Morton wrote:
>> Surely it would be better to fix the tools which display this info
>> rather than making the kernel tell fibs.
>
> The strncpy in get_task_comm() is totally wrong -- it's testing the length
> of task->comm.

It also fills not just any buffer but buffer which is TASK_COMM_LEN byte wide.

> Why should get_task_comm not take a destination buffer length argument?

If you pass too small, you needlessly truncate output.
If you pass too large, you waste space.
