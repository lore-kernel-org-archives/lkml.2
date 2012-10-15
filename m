Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab2JOOlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:41:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40497 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2JOOlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:41:49 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1210151029350.1702-100000@iolanthe.rowland.org>
References: <1350278059-14904-2-git-send-email-ming.lei@canonical.com>
	<Pine.LNX.4.44L0.1210151029350.1702-100000@iolanthe.rowland.org>
Date: Mon, 15 Oct 2012 22:41:48 +0800
Message-ID: <CACVXFVM=nNEthvSOzoTnoZ-7uhLGGmZ8ULsPu0N0d8QegtHYew@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mm: teach mm by current context info to not do
 I/O during memory allocation
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jiri.kosina@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 10:33 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Instead of allow/forbid, the API should be save/restore (like
> local_irq_save and local_irq_restore).  This makes nesting much easier.

Good point.

> Also, do we really the "p" argument?  This is not at all likely to be
> used with any task other than the current one.

Yes, only 'current' can be passed now. I keep it because no performance
effect with macro implementation. But that is not good since it may
cause misuse. Will remove the 'p' argument.

Thanks,
--
Ming Lei
