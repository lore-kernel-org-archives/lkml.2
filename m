Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab0LTPxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:53:12 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:37740 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0LTPxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:53:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q7ticqXaNGgS+n2ubkhBBV1w2HWC7tCPXM8GCo6h31V2U5V4xgcA15zS6uHe17galz
         sNmEw9gKSy/i5yU+HsJHFDNLKPevceH0gAFZIQqeUfx0db9C/PYAwXTZJOYRYrYVayoB
         bm12gV/17gmU+rMm+B6ysAErBNpwVa0WokOdY=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=3-FpuzXZ8xoEWCPhKrwydDOj0m4n-eEh-2BdT@mail.gmail.com>
References: <1290281700.28711.9.camel@maggy.simson.net>
	<tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
	<AANLkTimRfVFmuMJzuirgsc37=RhC6zKX0C0YXhXO44O9@mail.gmail.com>
	<1292851159.5021.2.camel@laptop>
	<AANLkTi=3-FpuzXZ8xoEWCPhKrwydDOj0m4n-eEh-2BdT@mail.gmail.com>
Date: Mon, 20 Dec 2010 21:23:09 +0530
Message-ID: <AANLkTi=qZHFCk=ACohxc1yajLQObn+A3SQ4KE25gtSnL@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Bharata B Rao <bharata.rao@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, torvalds@linux-foundation.org,
        efault@gmx.de, pjt@google.com, markus@trippelsdorf.de,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 9:16 PM, Bharata B Rao <bharata.rao@gmail.com> wrote:
> On Mon, Dec 20, 2010 at 6:49 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Mon, 2010-12-20 at 18:38 +0530, Bharata B Rao wrote:
>>> The autogroup patchset removes the display of cgroup name from
>>> sched_debug output.
>>
>> Hrmph.. that wasn't supposed to happen, care to send a patch to fix that
>> up?
>
> There are two aspects here:
>
> - Printing cgroup name for per-CPU cfs_rqs shouldn't be affected by
>  autogroup and the old code should work here.
> - Printing cgroup name for tasks depends on task_group(), which has
> been changed by autogroup patch. I haven't really looked deep into
> autogroup patch, but from whatever I can gather, Mike had a reason
> to remove this bit from sched_debug. The task groups created for
> autogroups don't have cgroups associated with them and hence no
> dentries and hence no pathnames.
>
> I guess we could do fix this as shown in the attached patch.

I missed adding the similar bits to RT in sched_dubug.c. If this
approach is reasonable, I can send the next one with RT changes
included.

Regards,
Bharata.
