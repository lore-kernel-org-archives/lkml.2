Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2G1Qh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 12:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab2G1Qh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 12:37:56 -0400
Date: Sat, 28 Jul 2012 18:34:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <anton@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: mmap_region() corrupts mm->mm_rb if
	uprobe_mmap() fails
Message-ID: <20120728163451.GA22727@redhat.com>
References: <20120728163157.GA22719@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120728163157.GA22719@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Oleg Nesterov wrote:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=843640
>
> If mmap_region()->uprobe_mmap() fails, unmap_and_free_vma path
> does unmap_region() but does not remove the soon-to-be-freed vma
> from rb tree (actually there are more problems).

Just in case...

Ingo, this is orthogonal to other pending changes I sent. I think
3.6 (and 3.5-stable) needs this fix.

Oleg.

