Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1GDWRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 18:17:36 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:50146 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab1GDWRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 18:17:34 -0400
From: Richard Weinberger <richard@nod.at>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
Date: Tue, 5 Jul 2011 00:17:29 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1309779003-8668-1-git-send-email-richard@nod.at> <201107041707.23165.richard@nod.at> <201107050703.EGJ13561.OFQHOOVMJtLFSF@I-love.SAKURA.ne.jp>
In-Reply-To: <201107050703.EGJ13561.OFQHOOVMJtLFSF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107050017.30365.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 05 Juli 2011, 00:03:47 schrieb Tetsuo Handa:
> Richard Weinberger wrote:
> > Am Montag 04 Juli 2011, 16:59:32 schrieb Richard Weinberger:
> > > Here the second boot log:
> > > http://userweb.kernel.org/~rw/boot2.log
> > > 
> > > The interesting part is:
> > > ---cut---
> > > VFS: Mounted root (ext2 filesystem) readonly on device 98:0.
> > > Calling request_module() swapper 1 /sbin/init 1 3
> > > Calling request_module() kworker/u:0 211 /sbin/modprobe 4 3
> > > ...
> > > Calling request_module() kworker/u:0 8741 /sbin/modprobe 4 3
> > > ---cut---
> > > 
> > > After the last "Calling request_module..." message no more messages
> > > appear and the kernel seems to loop for ever.
> > 
> > Please ignore this.
> > The "Calling request_module..." messages continue for ever.
> > In the first case my terminal locked up...
> > current->pid also wraps around.
> 
> Please note that the each PID is printed for twice.
> This means that each thread within the loop tries to create a thread.
> Therefore, it will repeat for (1 << MAX_KMOD_CONCURRENT) times.
> It is large enough to wrap the PID.
> Well, try with smaller MAX_KMOD_CONCURRENT (e.g. 3).
> 

With MAX_KMOD_CONCURRENT=3 it takes only a few seconds until 
the modprobe storm ends.

How shall we proceed?
Applying my ad-hoc patch 
or lowering MAX_KMOD_CONCURRENT?

Thanks,
//richard
