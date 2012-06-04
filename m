Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2FDAUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 20:20:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48572 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2FDAUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 20:20:33 -0400
Date: Mon, 4 Jun 2012 01:20:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120604002030.GT30000@ZenIV.linux.org.uk>
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120604000059.GA14144@redhat.com>
 <CA+55aFwJO40594yLH0gS_7YurDGAojVYfgBQXLNawraV_jdNsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwJO40594yLH0gS_7YurDGAojVYfgBQXLNawraV_jdNsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 05:16:30PM -0700, Linus Torvalds wrote:
> On Sun, Jun 3, 2012 at 5:00 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > sysrq-d: http://fpaste.org/ow9O/
> 
> Ugh. I'm adding PeterZ to the cc, just to see if he can make more sense of it.
> 
> Peter, is there no way to make the lock thing print not just the lock
> class name, but also the pointer to the actual *instance* of the lock
> held?
> 
> Also, it's a bit unclear to me, but I *think* that most of those users
> don't actually "hold" the lock - they are waiting for it. Yes/no?

Has to be, unless something _very_ odd is going on...  Just how many
->s_vfs_rename_mutex are there on that box?

> Does
> the lockdep information have the capability to distinguish between
> "waiting for" vs "actually successfully owns the lock"?

Another question re lockdep - does it scream loudly if process returns
to userland without having released some lock?  I hope so, but I've never
checked that... ;-/
