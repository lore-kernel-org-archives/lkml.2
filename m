Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1HPTkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:40:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38720 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab1HPTky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:40:54 -0400
Date: Tue, 16 Aug 2011 20:40:51 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Roland McGrath <mcgrathr@google.com>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Hugh Dickins <hughd@google.com>,
        Shaohua Li <shaohua.li@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mmap: add sysctl for controlling ~VM_MAYEXEC taint
Message-ID: <20110816194050.GB4484@csn.ul.ie>
References: <1313441856-1419-1-git-send-email-wad@chromium.org>
 <20110816093303.GA4484@csn.ul.ie>
 <CAB=4xhqu1FsJnNbHNeokyROvEFpRJYKhcHRLLw5QTVKOkbkWfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAB=4xhqu1FsJnNbHNeokyROvEFpRJYKhcHRLLw5QTVKOkbkWfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 10:07:46AM -0700, Roland McGrath wrote:
> On Tue, Aug 16, 2011 at 2:33 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> > Is using shm_open()+mmap instead of open()+mmap() to open a file on
> > /dev/shm really that difficult?
> >
> > int shm_open(const char *name, int oflag, mode_t mode);
> > int open(const char *pathname, int flags, mode_t mode);
> 
> I cannot figure out the rationale behind this question at all.
> Both of these library functions result in the same system call.
> 

They might result in the same system call but one of them creates
the file under /dev/shm which should not have the same permissions
problem. The library really appears to want to create a shared
executable object, using shm_open does not appear that unreasonable
to me.

> > An ordinary user is not going to know that a segfault from an
> > application can be fixed with this sysctl. This looks like something
> > that should be fixed in the library so that it can work on kernels
> > that do not have the sysctl.
> 
> I think the expectation is that the administrator or system builder
> who decides to set the (non-default) noexec mount option will also
> set the sysctl at the same time.
> 

Which then needs to be copied in each distro wanting to do the same
thing and is not backwards compatible where as using shm_open is.

-- 
Mel Gorman
SUSE Labs
