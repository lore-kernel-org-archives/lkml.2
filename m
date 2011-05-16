Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab1EPMLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:11:34 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:44415 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751751Ab1EPMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:11:33 -0400
Date: Mon, 16 May 2011 14:11:16 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: waitpid(WNOHANG) should report SIGCHLD-notified signals  [Re:
 [PATCH 09/11] job control: reorganize wait_task_stopped()]
Message-ID: <20110516121116.GB10469@host1.jankratochvil.net>
References: <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110515144017.GC31855@host1.jankratochvil.net>
 <20110515164705.GI23665@htj.dyndns.org>
 <20110515174722.GA26361@host1.jankratochvil.net>
 <20110516091318.GQ23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516091318.GQ23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, 16 May 2011 11:13:18 +0200, Tejun Heo wrote:
> On Sun, May 15, 2011 at 07:47:22PM +0200, Jan Kratochvil wrote:
> > If the debugger wants to be single-threaded ("poll() model", not "threads
> > model") and it wants to communicate with user and examine debuggee symbols and
> > memory data it cannot use sleeping wait.  GDB is single-threaded and it
> > supports `set target-async 1': info '(gdb)Background Execution'
> 
> I don't think target-async is necessarily related.  It doesn't really
> matter whether the execution per-se is async or not.  The ptracer can
> be a separate thread

It cannot as various GDB-supported platforms do not support threads properly.
And you want to have a common codebase to get it will supported.

Besides that it is a matter of coding style, I perfer "poll() model" even on
threads-supporting GNU/Linux.


> Anyways, I would recommend using sleeping wait(2)'s for ptrace event
> tracking.

You cannot as I described above.


Thanks,
Jan
