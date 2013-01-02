Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3ABVAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 16:00:39 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:57542 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab3ABVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 16:00:37 -0500
X-Greylist: delayed 1567 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2013 16:00:37 EST
MIME-Version: 1.0
In-Reply-To: <1357158557.3652.42.camel@bwh-desktop.uk.solarflarecom.com>
References: <cover.1356810877.git.decot@googlers.com> <796d4768f46d928c68018f44b369df570a0889c4.1356810877.git.decot@googlers.com>
 <20121229203644.GA31014@leaf> <1357158557.3652.42.camel@bwh-desktop.uk.solarflarecom.com>
From: David Decotigny <decot@googlers.com>
Date: Wed, 2 Jan 2013 12:34:09 -0800
Message-ID: <CAG88wWb9X1abn4yhcxPmM07pJU0RtKcTJOdOz-=g4+hu+Zdegg@mail.gmail.com>
Subject: Re: [PATCH v3] lib: cpu_rmap: avoid flushing all workqueues
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

I appreciate your review and clarification, as I was afraid there
could be something I missed. I will send v4 of this patch: an update
with the cpu_rmap_get helper that Josh suggested and the
"free_cpu_rmap" alias removed.

Regards,

--
David Decotigny

On Wed, Jan 2, 2013 at 12:29 PM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> On Sat, 2012-12-29 at 12:36 -0800, Josh Triplett wrote:
>> On Sat, Dec 29, 2012 at 11:57:09AM -0800, David Decotigny wrote:
>> > In some cases, free_irq_cpu_rmap() is called while holding a lock
>> > (eg. rtnl). This can lead to deadlocks, because it invokes
>> > flush_scheduled_work() which ends up waiting for whole system
>> > workqueue to flush, but some pending works might try to acquire the
>> > lock we are already holding.
>> >
>> > This commit uses reference-counting to replace
>> > irq_run_affinity_notifiers(). It also removes
>> > irq_run_affinity_notifiers() altogether.
>> >
>> > Signed-off-by: David Decotigny <decot@googlers.com>
>>
>> You might consider adding a cpu_rmap_get to parallel cpu_rmap_put.
>>
>> Also, why keep free_cpu_rmap around at this point?  As far as I can
>> tell, it has no callers.
>>
>> Otherwise, this looks good to me.
>
> I intended to make cpu_rmap usable independently of IRQ notification,
> although as you note there have been no other users so far.
> free_cpu_rmap() is now effectively an alias for cpu_rmap_put(), and the
> latter *does* have a caller.  So perhaps cpu_rmap_put() should be extern
> and the alias dropped.
>
> Ben.
>
> --
> Ben Hutchings, Staff Engineer, Solarflare
> Not speaking for my employer; that's the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.
>
