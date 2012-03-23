Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2CWRHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 13:07:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43733 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232Ab2CWRHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 13:07:11 -0400
Date: Fri, 23 Mar 2012 10:06:14 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-ID: <20120323170614.GD27292@count0.beaverton.ibm.com>
References: <20120316205556.595309230@openvz.org>
 <20120316210343.925446961@openvz.org>
 <20120319151507.93bab32a.akpm@linux-foundation.org>
 <20120319223941.GJ19594@moon>
 <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
 <20120319154649.0687f545.akpm@linux-foundation.org>
 <20120320065543.GB14269@moon>
 <m14ntgxl30.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14ntgxl30.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032317-2398-0000-0000-00000545A706
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 04:38:43PM -0700, Eric W. Biederman wrote:
> Cyrill Gorcunov <gorcunov@openvz.org> writes:
> 
> > On Mon, Mar 19, 2012 at 03:46:49PM -0700, Andrew Morton wrote:
> >> > >>
> >> > >> What is this mysterious "security reason"?
> >> > >>
> >> > >
> >> > > Oh, sorry I should have included Matt's comment here
> >> 
> >> Please send a patch with the updated changelog and improved comment?
> >> 
> >
> > Andrew, take a look please, will the changelog and comments look
> > better?
> 
> Can you change this to take an actual address and get the exe_file
> from an mmapped area and make certain that the mmaped_area is already
> mapped MAP_EXEC.

Do you mean PROT_EXEC/VM_EXEC?

> 
> That will prevent out-right lies.
> 
> At least then we will know that exe_file will at least be a file that is
> mapped executable in the process's address space.  It's not a lot better
> but it makes /proc/<pid>/exe at almost as trustable as it is now.

I don't dislike the idea. However just because it's mapped with one of
those flags does not mean that a single instruction of it will ever be
executed. So it's not much better than using the fd :/.

Perhaps there is some way to use the userspace stack and/or regs to get
a reasonable instruction pointer, lookup its VMA, and use that? I'm not
sure that would work for c/r though...

Cheers,
	-Matt

