Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2CIWDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:03:21 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49034 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab2CIWDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:03:19 -0500
Date: Fri, 9 Mar 2012 14:02:44 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309220244.GD19584@count0.beaverton.ibm.com>
References: <20120308214817.GO21812@moon>
 <20120309124811.GA610@redhat.com>
 <20120309125735.GB13346@moon>
 <20120309133555.GA23040@moon>
 <20120309134732.GA3696@redhat.com>
 <20120309141349.GC13346@moon>
 <20120309142620.GA5334@redhat.com>
 <20120309144239.GD13346@moon>
 <20120309152122.GA7802@redhat.com>
 <20120309154224.GE13346@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309154224.GE13346@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030922-5112-0000-0000-00000609D365
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 07:42:24PM +0400, Cyrill Gorcunov wrote:
> On Fri, Mar 09, 2012 at 04:21:22PM +0100, Oleg Nesterov wrote:

<snip>

> > Just one note for the record, prctl_set_mm_exe_file() does
> > 
> > 	if (mm->num_exe_file_vmas)
> > 		return -EBUSY;
> > 
> > We could do
> > 
> > 	if (mm->exe_file)
> > 		return -EBUSY;
> > 
> > This way "because this feature is a special to C/R" becomes
> > really true. IOW, you can't do PR_SET_MM_EXE_FILE twice.
> > 
> 
> Sure, i'll make it this way. Thanks a lot, Oleg!!!

Sorry about the other email -- hadn't full caught up on this thread.
This is even better, yes.

Of course I'd prefer it if there was a way to keep num_exe_file_vmas
correct and not special-case c/r. The first approximation of a solution
might be to increment the count whenever a new mmap filp == mm->exe_file
and decrement on unmap. I think there are a bunch of details needed to
make that work but my feeling is it's do-able. Have you investigated this
already and rejected it for some reason (did I miss that discussion
somehow?)?

Cheers,
	-Matt Helsley

