Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1BXM0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:26:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab1BXM0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:26:52 -0500
Message-ID: <4D664E85.8070808@redhat.com>
Date: Thu, 24 Feb 2011 14:26:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
 boot
References: <20110223234258.GA29548@nik-comp.lan> <4D663044.3080000@redhat.com> <20110224104800.GA29840@pcnci.linuxbox.cz> <4D663886.6080803@redhat.com> <20110224112742.GB29840@pcnci.linuxbox.cz>
In-Reply-To: <20110224112742.GB29840@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 01:27 PM, Nikola Ciprich wrote:
> >  Not very useful when the guest is making progress, I'm afraid.
> can perf report help here?
>
> >  Can you try a little trace-cmd -e kvm -b 20000?
> ugh, I'm afraid I'll have some dumb questions here :-[
> You mean this: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git ?

Yes.  If you have udis86 and udis86-devel installed when building it, 
it's even better.

> and then re-execute qemu-kvm using it? or I'm totally wrong?

You don't have to execute qemu-kvm under it, if you have a running 
instance you can run trace-cmd in parallel and it will record whatever's 
happening.

> >  Sure.  Something similar that came up - sometimes Windows IDE drivers
> >  fall back to PIO mode.  Are you using IDE?  If so, please check whether
> >  it's using DMA or PIO.
> I'll check, but this problem occurs only during fsck phase, when to guest boots, then it runs pretty fast..
> so maybe during boot it might fall back to PIO, but from guest, I guess I won't have a chance
> to find out.. can I somehow check it from host?

The trace-cmd output will show.  Please run trace-cmd report afterwards 
and post the results somewhere.


-- 
error compiling committee.c: too many arguments to function

