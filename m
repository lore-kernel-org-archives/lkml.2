Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469Ab2CIWjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 17:39:37 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38740 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab2CIWjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 17:39:36 -0500
Date: Sat, 10 Mar 2012 02:39:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309223932.GB725@moon>
References: <20120309124811.GA610@redhat.com>
 <20120309125735.GB13346@moon>
 <20120309133555.GA23040@moon>
 <20120309134732.GA3696@redhat.com>
 <20120309141349.GC13346@moon>
 <20120309142620.GA5334@redhat.com>
 <20120309144239.GD13346@moon>
 <20120309152122.GA7802@redhat.com>
 <20120309154224.GE13346@moon>
 <20120309220244.GD19584@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309220244.GD19584@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 02:02:44PM -0800, Matt Helsley wrote:
...
> 
> Sorry about the other email -- hadn't full caught up on this thread.

No problem.

> This is even better, yes.
>

Well, in final version I switched back to

+	if (mm->num_exe_file_vmas)
+		return -EBUSY;

simply because it's more flexible than mm->exe_file.

With mm->exe_file this prctl option become a one-shot
only, and while at moment our user-space tool can perfectly
live with that I thought that there is no strict need to
limit the option this way from the very beginning.

> Of course I'd prefer it if there was a way to keep num_exe_file_vmas
> correct and not special-case c/r. The first approximation of a solution

It remains correct actually. There is no way to map new VM_EXECUTABLE
from user-space after we've unmapped previous ones, so num_exe_file_vmas
will remain 0.

> might be to increment the count whenever a new mmap filp == mm->exe_file
> and decrement on unmap. I think there are a bunch of details needed to
> make that work but my feeling is it's do-able. Have you investigated this
> already and rejected it for some reason (did I miss that discussion
> somehow?)?

As far as I understand overall num_exe_file_vmas concept -- we track
a number of VM_EXECUTABLE with it, so setting new exe_file should not
change num_exe_file_vmas I think.

	Cyrill
