Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2F2NEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:04:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49635 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab2F2NES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:04:18 -0400
Message-ID: <1340974925.2309.13.camel@falcor>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Fri, 29 Jun 2012 09:02:05 -0400
In-Reply-To: <20120629083311.GX14083@ZenIV.linux.org.uk>
References: <20120623194505.GI14083@ZenIV.linux.org.uk>
	 <20120623203800.GA10306@redhat.com>
	 <20120623210141.GK14083@ZenIV.linux.org.uk>
	 <20120624041652.GN14083@ZenIV.linux.org.uk>
	 <20120624153310.GB24596@redhat.com>
	 <20120625060357.GT14083@ZenIV.linux.org.uk>
	 <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com>
	 <20120628043836.GW14083@ZenIV.linux.org.uk>
	 <1340947838.2293.2.camel@falcor>
	 <20120629083311.GX14083@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12062913-7182-0000-0000-000001E23AAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 09:33 +0100, Al Viro wrote:
> On Fri, Jun 29, 2012 at 01:30:38AM -0400, Mimi Zohar wrote:
> > On Thu, 2012-06-28 at 05:38 +0100, Al Viro wrote:
> > > On Wed, Jun 27, 2012 at 08:37:21PM +0200, Oleg Nesterov wrote:
> > > > On 06/25, Oleg Nesterov wrote:
> > > > >
> > > > > And if it always takes ->pi_lock we do not need the new PF_ or something
> > > > > else, exit_task_work() can set task->task_works = NO_MORE under ->pi_lock
> > > > > (task_work_run() can check PF_EXITING), and task_work_add() ensures that
> > > > > task_works != NO_MORE.
> > > > >
> > > > > What do you think?
> > > > 
> > > > It is not clear to me if you agree or not. So I am simply sending the
> > > > patches I have.
> > > > 
> > > > Feel free to ignore or re-do.
> > > > 
> > > > Seriously, why should we add 2 pointers into task_struct? Sure, this
> > > > is minor, but still... But perhaps task_work.c should not play tricks
> > > > with the circular list, task_work_run() can reverse the list as you
> > > > initially suggested.
> > > > 
> > > > Also, I am not sure about "define rcu_head callback_head", this series
> > > > doesn't do this. But again, up to you.
> > > 
> > > Umm...  FWIW, my variant circa yesterday is in vfs.git#untested; it seems to survive
> > > on uml/amd64 at least.  I'll look through your patches and see what can be nicked.
> > > The list removal logics in mine looks really ugly ;-/
> > 
> > Still failing to boot.  Fails to boot starting with commit "b24dfa6
> > switch fput to task_work_add".
> 
> Details, please...  .config, root fs type, etc.  Failed execve() of init is, unfortunately,
> not too informative...

In addition to failing with my tailored .config (eg. IMA, TPM builtin),
it fails with config-3.4.2-1.fc16.x86_64, with new default options,
running on a Lenovo W520.

/dev/sda7 on / type ext4 (rw,relatime,seclabel,i_version,data=ordered)

Mimi

