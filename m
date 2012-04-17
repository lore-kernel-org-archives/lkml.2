Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab2DQTTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:19:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43074 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2DQTTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:19:21 -0400
Date: Tue, 17 Apr 2012 23:19:16 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH c/r -mm] c/r: prctl: Simplify PR_SET_MM on mm::code/data
 assignment
Message-ID: <20120417191916.GQ1906@moon>
References: <20120416225520.GD9756@moon>
 <CAGXu5jKnfOsXGTx8QbKCCH9C9c+szFwi5oA1R99pjCue9kfpWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKnfOsXGTx8QbKCCH9C9c+szFwi5oA1R99pjCue9kfpWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:22:06AM -0700, Kees Cook wrote:
> On Mon, Apr 16, 2012 at 3:55 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > The mm::start_code, end_code, start_data, end_data members
> > are set during startup of executable file and are not changed
> > after.
> >
> > But the program itself might map new executable or/and data areas in
> > time so the original values written into mm fields mentioned above
> > might not have correspond VMA area at all, thus if one try to
> > use this prctl codes without underlied VMA, the error will be
> > returned.
> >
> > Drop this requirement. This shrinks the code and eliminates
> > redundant calls to vma_flags_mismatch. The worst thing one can
> > do (if say to write some bad values here) -- the weird results
> > will be shown in /proc/$pid/statm or in /proc/pid/stat.
> >
> > Still, assignement of data on stack (such as command line and
> > environment variables) requires the underlied VMA to exist.
> >
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> 
> Since this is CAP_SYS_RESOURCE, and mmap_min_addr is CAP_SYS_RAWIO,
> how about a lower-bounds check against mmap_min_addr? (We're already
> doing the TASK_SIZE upper check, so this additional sanity checking
> seems reasonable to me.)

I think this is good idea, thanks Kees. I'll check it out.

	Cyrill
