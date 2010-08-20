Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0HTMQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:16:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:51692 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab0HTMQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:16:32 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree: directory events
Date: Fri, 20 Aug 2010 14:16:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008200141.10068.agruen@suse.de> <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008201416.10679.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 05:38:17 Eric Paris wrote:
> As to when a listener dies:  You have to define 'dies'.

I meant a process that gets killed or simply exits while there are outstanding 
perm events.  Nothing in the code would wake up the processes blocked on the 
perm event; they will simply be stuck forever.  (They cannot even be killed 
with SIGKILL.)

This is easy to reproduce with a listener that is killed while processing a 
perm event: just run the fanotify example [1] with the new -s option and hit 
^C while it is sleeping.

Bonus points would be awarded to make a process blocked on a listener killable 
with SIGKILL or other lethal signals.

[1] http://git.kernel.org/?p=linux/kernel/git/agruen/fanotify-example.git

The listener will also hang forever in that case; not sure why that is the 
case.

I already told you about this before (http://lkml.org/lkml/2010/8/16/349); not 
sure why everything needs to repeated multiple times until it sinks in.

> If the process just stops respond it is supposed to lock forever.

I agree.

> I was explicitly ask to remove timeouts (even though I've already been ask
> off list to put them back)

I disagree with putting timeouts back in.

> In Linus' tree there is a race in which both processes (the
> listener and the process doing an action waiting on the listener) can
> deadlock and hang forever.  A (much less racy but not right) patch to
> fix this has already been posted.
>
> I have a better version which has worked well for me today which I will
> likely post tomorrow morning after I look over it again.  I'd love your
> feedback.

Do you have a pointer to that?

Thanks,
Andreas
