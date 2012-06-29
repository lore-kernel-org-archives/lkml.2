Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2F2Id2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 04:33:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33319 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2F2IdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 04:33:24 -0400
Date: Fri, 29 Jun 2012 09:33:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120629083311.GX14083@ZenIV.linux.org.uk>
References: <20120623194505.GI14083@ZenIV.linux.org.uk>
 <20120623203800.GA10306@redhat.com>
 <20120623210141.GK14083@ZenIV.linux.org.uk>
 <20120624041652.GN14083@ZenIV.linux.org.uk>
 <20120624153310.GB24596@redhat.com>
 <20120625060357.GT14083@ZenIV.linux.org.uk>
 <20120625151812.GA16062@redhat.com>
 <20120627183721.GA23086@redhat.com>
 <20120628043836.GW14083@ZenIV.linux.org.uk>
 <1340947838.2293.2.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340947838.2293.2.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 01:30:38AM -0400, Mimi Zohar wrote:
> On Thu, 2012-06-28 at 05:38 +0100, Al Viro wrote:
> > On Wed, Jun 27, 2012 at 08:37:21PM +0200, Oleg Nesterov wrote:
> > > On 06/25, Oleg Nesterov wrote:
> > > >
> > > > And if it always takes ->pi_lock we do not need the new PF_ or something
> > > > else, exit_task_work() can set task->task_works = NO_MORE under ->pi_lock
> > > > (task_work_run() can check PF_EXITING), and task_work_add() ensures that
> > > > task_works != NO_MORE.
> > > >
> > > > What do you think?
> > > 
> > > It is not clear to me if you agree or not. So I am simply sending the
> > > patches I have.
> > > 
> > > Feel free to ignore or re-do.
> > > 
> > > Seriously, why should we add 2 pointers into task_struct? Sure, this
> > > is minor, but still... But perhaps task_work.c should not play tricks
> > > with the circular list, task_work_run() can reverse the list as you
> > > initially suggested.
> > > 
> > > Also, I am not sure about "define rcu_head callback_head", this series
> > > doesn't do this. But again, up to you.
> > 
> > Umm...  FWIW, my variant circa yesterday is in vfs.git#untested; it seems to survive
> > on uml/amd64 at least.  I'll look through your patches and see what can be nicked.
> > The list removal logics in mine looks really ugly ;-/
> 
> Still failing to boot.  Fails to boot starting with commit "b24dfa6
> switch fput to task_work_add".

Details, please...  .config, root fs type, etc.  Failed execve() of init is, unfortunately,
not too informative...
