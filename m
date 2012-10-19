Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2JSDwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:52:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59166 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2JSDwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:52:22 -0400
MIME-Version: 1.0
In-Reply-To: <20121017165401.cc343861.akpm@linux-foundation.org>
References: <1350403183-12650-1-git-send-email-ming.lei@canonical.com>
	<1350403183-12650-2-git-send-email-ming.lei@canonical.com>
	<20121016131933.c196457a.akpm@linux-foundation.org>
	<CACVXFVPRsHTf85bTsHUWgHV2b7LBASGQ2s_9Kx9-ZCHv5WDuQQ@mail.gmail.com>
	<20121017165401.cc343861.akpm@linux-foundation.org>
Date: Fri, 19 Oct 2012 11:52:19 +0800
Message-ID: <CACVXFVNwZp0e=5vu4NFePnU=y6TaSKs4qS7q7j1cfRuQ42Ms9g@mail.gmail.com>
Subject: Re: [RFC PATCH v1 1/3] mm: teach mm by current context info to not do
 I/O during memory allocation
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        Jiri Kosina <jiri.kosina@suse.com>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 7:54 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> local_irq_save() and local_irq_restore() were mistakes :( It's silly to
> write what appears to be a C function and then have it operate like
> Pascal (warning: I last wrote some Pascal in 66 B.C.).

Considered that spin_lock_irqsave/spin_unlock_irqrestore also follow
the style, kernel guys have been accustomed to the usage, I am
inclined to keep that as macro, :-)

>> IMO, renaming as memalloc_noio_set() might not be better than _save
>> because the _set name doesn't indicate that the flag should be stored first.
>
> You could add __must_check to the function definition to ensure that
> all callers save its return value.

Yes, we can do that, but the function name is not better than _save
from readability.

Thanks,
--
Ming Lei
