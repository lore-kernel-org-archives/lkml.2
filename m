Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1GDMUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 08:20:34 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:56044 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab1GDMUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 08:20:33 -0400
From: Richard Weinberger <richard@nod.at>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
Date: Mon, 4 Jul 2011 14:20:30 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1309779003-8668-1-git-send-email-richard@nod.at> <201107041357.43481.richard@nod.at> <201107042110.EDI30723.OLFHOtQSMOFFJV@I-love.SAKURA.ne.jp>
In-Reply-To: <201107042110.EDI30723.OLFHOtQSMOFFJV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041420.31049.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 04 Juli 2011, 14:10:43 schrieb Tetsuo Handa:
> Richard Weinberger wrote:
> > Am Montag 04 Juli 2011, 13:51:55 schrieb Tetsuo Handa:
> > > Richard Weinberger wrote:
> > > > Running a x86_64 kernel without ia32 emulation and a x86 user land
> > > > triggers this issue.
> > > 
> > > Executing /sbin/modprobe for x86_32 on an x86_64 kernel without x86_32
> > > support?
> > 
> > Yep.
> > 
> > > Anyway, request_module() calls __request_module() but
> > > __request_module() stops at MAX_KMOD_CONCURRENT levels of nesting.
> > > So, I think "infinite loop" cannot happen.
> > 
> > Booting a x86_64 UML kernel with x86_32 user land triggers this issue.
> > I always wondered why the UML kernel hangs an consumes 100% CPU.
> 
> That's strange... Would you show us printk() output like
> 
> 	printk(KERN_INFO "Calling request_module()\n");
> 	request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
> 	printk(KERN_INFO "Returned from request_module()\n");
> 
> for demonstrating that __request_module() cannot stop at
> MAX_KMOD_CONCURRENT levels of nesting?

There you go!
http://userweb.kernel.org/~rw/boot.log

I did not count all messages, but they are more than 50. :-)

Thanks,
//richard
