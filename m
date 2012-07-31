Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab2GaN24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:28:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab2GaN2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:28:53 -0400
Date: Tue, 31 Jul 2012 15:25:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: mmap_region() corrupts mm->mm_rb if
	uprobe_mmap() fails
Message-ID: <20120731132542.GA2854@redhat.com>
References: <20120728163157.GA22719@redhat.com> <20120731064730.GB5087@linux.vnet.ibm.com> <20120731124805.GA485@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731124805.GA485@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Oleg Nesterov wrote:
>
> OK, so what you suggest for now?
>
> Please note that it is very trivial to crash the kernel. Just
> do something like
>
> 	echo "p /bin/true:OFFSET_OF_SYSCALL_INSN" > /sys/kernel/debug/tracing/uprobe_events
> 	/bin/true

Forgot to mention...

And even it it didn't crash, mmap() (and thus exec) should not fail.

Oleg.

