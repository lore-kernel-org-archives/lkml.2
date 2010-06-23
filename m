Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0FWTZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:25:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40115 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab0FWTZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:25:32 -0400
Message-ID: <4C225F40.8000008@zytor.com>
Date: Wed, 23 Jun 2010 12:23:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Christoph Hellwig <hch@lst.de>, Ian Munsie <imunsie@au1.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, x86@kernel.org,
       Jason Baron <jbaron@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/40] x86, compat: convert ia32 layer to use
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-13-git-send-email-imunsie@au1.ibm.com> <20100623101402.GA10564@lst.de> <20100623103619.GC5242@nowhere> <20100623104603.GB11845@lst.de> <20100623114116.GE5242@nowhere>
In-Reply-To: <20100623114116.GE5242@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 04:41 AM, Frederic Weisbecker wrote:
> On Wed, Jun 23, 2010 at 12:46:04PM +0200, Christoph Hellwig wrote:
>> On Wed, Jun 23, 2010 at 12:36:21PM +0200, Frederic Weisbecker wrote:
>>> I think we wanted that to keep the sys32_ prefixed based naming, to avoid
>>> collisions with generic compat handler names.
>>
>> For native syscalls we do this by adding a arch prefix inside the
>> syscall name, e.g.:
>>
>> arch/s390/kernel/sys_s390.c:SYSCALL_DEFINE(s390_fallocate)(int fd, int mode, loff_t offset,
>> arch/sparc/kernel/sys_sparc_64.c:SYSCALL_DEFINE1(sparc_pipe_real, struct pt_regs *, regs)
> 
> In fact we sort of wanted to standardize the name of arch overriden compat
> syscalls, so that userspace programs playing with syscalls tracing won't have
> to deal with arch naming differences.
> 

That seems totally wrong in so many ways.

What userspace sees is the system call name, e.g. fallocate or pipe.  It
should *not* be visible to userspace that there is an arch-specici
implementation.

There are already a huge amount of gratuitous user space ABI
differences, of course, partly because we *still* don't actually have a
systematic model for argument passing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

