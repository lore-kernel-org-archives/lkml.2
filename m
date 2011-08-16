Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab1HPRHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:07:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48208 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1HPRHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:07:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=WWF/ffuw8aM5xTMqfNN/bB1z0ngUMnnU2waW8r4BEXovyzPPKLB/e7tGxldls6clV
	SREWOSqW/tNVRlEZUNsxg==
MIME-Version: 1.0
In-Reply-To: <20110816093303.GA4484@csn.ul.ie>
References: <1313441856-1419-1-git-send-email-wad@chromium.org>
	<20110816093303.GA4484@csn.ul.ie>
Date: Tue, 16 Aug 2011 10:07:46 -0700
Message-ID: <CAB=4xhqu1FsJnNbHNeokyROvEFpRJYKhcHRLLw5QTVKOkbkWfQ@mail.gmail.com>
Subject: Re: [PATCH] mmap: add sysctl for controlling ~VM_MAYEXEC taint
From: Roland McGrath <mcgrathr@google.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Hugh Dickins <hughd@google.com>,
        Shaohua Li <shaohua.li@intel.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 2:33 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> Is using shm_open()+mmap instead of open()+mmap() to open a file on
> /dev/shm really that difficult?
>
> int shm_open(const char *name, int oflag, mode_t mode);
> int open(const char *pathname, int flags, mode_t mode);

I cannot figure out the rationale behind this question at all.
Both of these library functions result in the same system call.

> An ordinary user is not going to know that a segfault from an
> application can be fixed with this sysctl. This looks like something
> that should be fixed in the library so that it can work on kernels
> that do not have the sysctl.

I think the expectation is that the administrator or system builder
who decides to set the (non-default) noexec mount option will also
set the sysctl at the same time.


Thanks,
Roland
