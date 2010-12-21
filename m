Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab0LUFE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:04:29 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:45529 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0LUFE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:04:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ArUS0tzgsWgxRAagLGuqWDCs9DU8PRrD5Kmqt/QZaGZ6L6wE7QdzWjjTiE6AQM9ksG
         91DwIr9IwS7cSnJGeJnsJ+bHuX3e+/yHzsLdnL1eB/QkqtlGrFjXXXh0kLx2O67kINWm
         na8At59UtHKvuZGZbLc2b02SIayKND9ANoK0I=
MIME-Version: 1.0
In-Reply-To: <1292863193.19476.9.camel@marge.simson.net>
References: <1290281700.28711.9.camel@maggy.simson.net>
	<tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
	<AANLkTimRfVFmuMJzuirgsc37=RhC6zKX0C0YXhXO44O9@mail.gmail.com>
	<1292851159.5021.2.camel@laptop>
	<AANLkTi=3-FpuzXZ8xoEWCPhKrwydDOj0m4n-eEh-2BdT@mail.gmail.com>
	<1292863193.19476.9.camel@marge.simson.net>
Date: Tue, 21 Dec 2010 10:34:26 +0530
Message-ID: <AANLkTikdarpzXgLA5Ve-9bjaDbNpnjOShioE3yf2ytp0@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Bharata B Rao <bharata.rao@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        torvalds@linux-foundation.org, pjt@google.com, markus@trippelsdorf.de,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 10:09 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Mon, 2010-12-20 at 21:16 +0530, Bharata B Rao wrote:
>> On Mon, Dec 20, 2010 at 6:49 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > On Mon, 2010-12-20 at 18:38 +0530, Bharata B Rao wrote:
>> >> The autogroup patchset removes the display of cgroup name from
>> >> sched_debug output.
>> >
>> > Hrmph.. that wasn't supposed to happen, care to send a patch to fix that
>> > up?
>>
>> There are two aspects here:
>>
>> - Printing cgroup name for per-CPU cfs_rqs shouldn't be affected by
>>   autogroup and the old code should work here.
>> - Printing cgroup name for tasks depends on task_group(), which has
>> been changed by autogroup patch. I haven't really looked deep into
>> autogroup patch, but from whatever I can gather, Mike had a reason
>> to remove this bit from sched_debug. The task groups created for
>> autogroups don't have cgroups associated with them and hence no
>> dentries and hence no pathnames.
>
> Mike didn't remove it, but _was_ supposed to get around to it.
>
>> I guess we could do fix this as shown in the attached patch.
>
>
> +#ifdef CONFIG_CGROUP_SCHED
> +       {
> +               char path[64];
> +
>
> ...
>
> +#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
> +       char path[128];
>
>
> One reason it was removed was path[64/128].

Other callers of cgroup_path use PATH_MAX=4096 here. I believe the
original reason for these short path sizes was to be light on stack
and as well as to avoid allocation. Can we have some reasonable length
(256 or 512 ?) and live with truncation (if that ever happens) ?

Also, while displaying group name with tasks, does it make sense to
display autogroup-<id> (the one shown in /proc/<pid>/autogroup) ?

Regards,
Bharata.
