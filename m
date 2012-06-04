Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab2FDABF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 20:01:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab2FDABE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 20:01:04 -0400
Date: Sun, 3 Jun 2012 20:00:59 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120604000059.GA14144@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 04:07:35PM -0700, Linus Torvalds wrote:
 > On Sun, Jun 3, 2012 at 3:36 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > It's still up and in this state if you want me to gather any further info
 > > before I reboot it.
 > 
 > You seem to have lockdep enabled, since I see the lock information,
 > but presumably you didn't get a lockdep splat before this?

Nothing.

 > Because yes, it looks like you have a boattload of trinity processes
 > stuck on an inode mutex. Looks like every single one of them is in
 > 'lock_rename()'. It *shouldn't* be an ABBA deadlock, since lockdep
 > should have noticed that, but who knows.

another data point: the core dumps that were being deleted were in the
directory that trinity runs from. It's feasible that some of the processes
were using those dumps as input data for random syscalls, before they
got deleted.

 > It looks like the lock information is somewhat truncated. I suspect
 > the dmesg buffer had filled up with all the task data.
 > 
 > Can you do just "sysrq-d" for the lock information (and maybe
 > separately "sysrq-w" for the blocked tasks)? The non-truncated lock
 > data might tell us more.

sysrq-w: http://fpaste.org/WUd9/

sysrq-d: http://fpaste.org/ow9O/

	Dave
