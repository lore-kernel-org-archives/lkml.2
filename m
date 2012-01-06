Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab2AFK7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:59:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab2AFK7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:59:16 -0500
Date: Fri, 6 Jan 2012 03:03:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: "Michal Marek" <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] consolidate WARN_...ONCE() static variables
Message-Id: <20120106030329.d934f5bc.akpm@linux-foundation.org>
In-Reply-To: <4F06B37D020000780006AC1F@nat28.tlf.novell.com>
References: <4EF3609D0200007800069A30@nat28.tlf.novell.com>
	<20120104150305.8b2ab00c.akpm@linux-foundation.org>
	<4F059304020000780006A906@nat28.tlf.novell.com>
	<20120105130324.44949af9.akpm@linux-foundation.org>
	<4F06B37D020000780006AC1F@nat28.tlf.novell.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jan 2012 07:40:29 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:

> >>> On 05.01.12 at 22:03, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu, 05 Jan 2012 11:09:40 +0000
> > "Jan Beulich" <JBeulich@suse.com> wrote:
> > 
> >> >>> On 05.01.12 at 00:03, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> > On Thu, 22 Dec 2011 15:53:49 +0000
> >> > "Jan Beulich" <JBeulich@suse.com> wrote:
> >> > 
> >> >> Due to the alignment of following variables, these typically consume
> >> >> more than just the single byte that 'bool' requires, and as there are
> >> >> a few hundred instances, the cache pollution (not so much the waste of
> >> >> memory) sums op. Put these variables into their own section, outside
> >> >> of half way frequently used memory range.
> >> >> 
> >>
> >> ...
> >>
> >> > printk_once() should also be converted.  And ata_print_version_once(),
> >> > if it insists on continuing to exist.
> >> 
> >> I disagree for those (and intentionally didn't touch printk_once();
> >> wasn't aware of the other) - at best this could get marked
> >> __read_mostly, but that's not the subject of this patch.
> > 
> > Confused.  It is exactly the subject of the patch?
> 
> No - the goal here is to eliminate the wasteful alignment holes
> created by the __warned variables in the WARN_...ONCE()
> instances.

What are these alignment holes?  I'd assumed (without thinking a lot)
that they were little three or two byte gaps because sizeof(bool)=1 or
2.  But I see that sizeof(bool) is actually 4, so I don't know what
you're talking about.

Apparently there is some gcc behaviour which you know about and I
don't.

> These get accessed past and unlikely() condition,
> and hence get moved into a separate data section (so they
> would all end up together, with no holes in between).
>
>
> ...
>
> > I'm suspecting that there is some changelog crappiness going on here. 
> > What didn't you tell us?
> 
> I think the original description says all that it has to.

If it did that, I wouldn't have had any questions to ask you.
