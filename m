Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934498Ab0KPNEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:04:12 -0500
Received: from ist.d-labs.de ([213.239.218.44]:58165 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934484Ab0KPNEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:04:11 -0500
Date: Tue, 16 Nov 2010 14:03:41 +0100
From: Florian Mickler <florian@mickler.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Newsgroups: gmane.linux.kernel
Cc: Valdis.Kletnieks@vt.edu, Jesper Juhl <jj@chaosbits.net>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
Message-ID: <20101116140341.42561c84@schatten.dmk.lab>
In-Reply-To: <20101116110310.1502de2a@lxorguk.ukuu.org.uk>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com>
	<20101114181905.bc5b44f9.akpm@linux-foundation.org>
	<20101115113238.BF06.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
	<alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
	<34565.1289866395@localhost>
	<20101116110310.1502de2a@lxorguk.ukuu.org.uk>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 11:03:10 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > 5.6p1 is the latest-n-greatest released version on www.openssh.org, so somebody
> > probably needs to rattle their chain...
> 
> But current openssh needs to support old kernels.
> 
> This is why this kind of obsoleting doesn't work well. It's not "update
> your app" so much as "drop support for older stuff or start doing
> complicated crap dependant on version"
> 
> and it's why for tiny amounts of code it is the *wrong* thing to force
> obsolete stuff especially when it still doesn't seem to have been
> properly marked for deprecation in the first place.
> 

How does one mark it apropriately?
The commit 51b1bd2 (oom: deprecate oom_adj tunable, see below) 
added it to feature-removal-schedule.txt, a patch for
Documentation/ABI has also been provided in the meantime, if i'm not
mistaken. 

And there is already a patch for openssh:
https://bugzilla.mindrot.org/show_bug.cgi?id=1838

Regards,
Flo

commit 51b1bd2ace1595b72956224deda349efa880b693
Author: David Rientjes <rientjes@google.com>
Date:   Mon Aug 9 17:19:47 2010 -0700

    oom: deprecate oom_adj tunable
    
    /proc/pid/oom_adj is now deprecated so that that it may eventually be
    removed.  The target date for removal is August 2012.
    
    A warning will be printed to the kernel log if a task attempts to use this
    interface.  Future warning will be suppressed until the kernel is rebooted
    to prevent spamming the kernel log.
    
    Signed-off-by: David Rientjes <rientjes@google.com>
    Cc: Nick Piggin <npiggin@suse.de>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Cc: Balbir Singh <balbir@in.ibm.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
