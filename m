Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1HBBaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:30:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab1HBBaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:30:06 -0400
Date: Mon, 1 Aug 2011 18:32:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rientjes@google.com
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
Message-Id: <20110801183207.cea89a96.akpm@linux-foundation.org>
In-Reply-To: <20110802005206.GA3832@tassilo.jf.intel.com>
References: <20110802005206.GA3832@tassilo.jf.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011 17:52:06 -0700 Andi Kleen <andi@firstfloor.org> wrote:

> 
> Hi Linus,
> 
> Can you please revert 
> 
> commit be8f684d73d8d916847e996bf69cef14352872c6
> Author: David Rientjes <rientjes@google.com>
> Date:   Mon Jul 25 17:12:18 2011 -0700
> 
>     oom: make deprecated use of oom_adj more verbose
> 
>     /proc/pid/oom_adj is deprecated and scheduled for removal in August 2012
>     according to Documentation/feature-removal-schedule.txt.
> 
> 
> This makes most of my test systems (suse 11.1, 11.2) spew scary WARN_ONs
> on every boot. GNOME then also complains.

aw, what crap.

"/proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead."

Once per boot.  That's not "scary".

> While it doesn't cause actual 
> misfunction it scares me every time I boot and other people who can't
> read git logs like me will be unnecessary scared.

What?  Look at the damn text - the only reason anyone would need to
read a git log after looking at that is terminal cretinism.

> Also the warning is completely useless: noone will be "fixing"
> udev on old distributions.

I bet there were still old copies of /sbin/update lying around, but we
still managed to remove sys_bdflush() this way.

> IMHO that's not acceptable to break common user land like this.
> Linux is supposed to be binary compatible and this patch is not
> in this spirit.
> 
> Actually removing the file later should be still fine, but 
> not printing out these scary messages.
> 
> I propose to revert this misguided patch for stable and 3.1
> 

I see lots of fake reasoning.  What's really going on here??
