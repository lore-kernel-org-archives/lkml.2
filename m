Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab0ELTnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:43:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25167 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300Ab0ELTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:43:40 -0400
Date: Wed, 12 May 2010 12:42:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>, Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: mmotm 2010-05-11-18-20 uploaded (aio build; add numa)
Message-Id: <20100512124244.20365b3c.randy.dunlap@oracle.com>
In-Reply-To: <x49bpclrqtt.fsf@segfault.boston.devel.redhat.com>
References: <201005120149.o4C1n7P4002637@imap1.linux-foundation.org>
	<20100512095043.cc5d22b3.randy.dunlap@oracle.com>
	<x49bpclrqtt.fsf@segfault.boston.devel.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BEB04DA.00AA:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 13:07:58 -0400 Jeff Moyer wrote:

> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
> > On Tue, 11 May 2010 18:21:22 -0700 akpm@linux-foundation.org wrote:
> >
> >> The mm-of-the-moment snapshot 2010-05-11-18-20 has been uploaded to
> >> 
> >>    http://userweb.kernel.org/~akpm/mmotm/
> >> 
> >> and will soon be available at
> >> 
> >>    git://zen-kernel.org/kernel/mmotm.git
> >
> >
> > aio-fix-the-compat-vectored-operations.patch:
> >
> > (1) when CONFIG_AIO is not enabled, there are hundreds of this warning:
> >
> > include/linux/aio.h:226: warning: no return statement in function returning non-void
> >
> >
> > (2) when CONFIG_AIO=y, CONFIG_IA32_EMULATION=n, CONFIG_COMPAT=n:
> >
> > fs/aio.c:1393: error: implicit declaration of function 'compat_rw_copy_check_uvector'
> 
> Sorry about that.  I'll fix it up, but probably can't get to it until
> Monday.  Hopefully that's an ok timeframe.


Andrew's patch works_for_me.  (Ack)


During the build, I got another (unrelated) build error:

kernel/built-in.o: In function `copy_process':
fork.c:(.text+0x162b6): undefined reference to `__node_random'
fork.c:(.text+0x162cd): undefined reference to `__node_random'

kernel/fork.c needs to #include <linux/nodemask.h>

[builds...]

But that is not enough.  The config file has CONFIG_CPUSETS=y
and CONFIG_NUMA=n, so __node_random() is not being built at all.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
