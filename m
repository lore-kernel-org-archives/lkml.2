Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965354Ab2CARFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:05:05 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34925 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524Ab2CARFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:05:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of surovegin@google.com designates 10.229.134.199 as permitted sender) smtp.mail=surovegin@google.com; dkim=pass header.i=surovegin@google.com
MIME-Version: 1.0
In-Reply-To: <20120301150957.GA13533@redhat.com>
References: <1330536083-13098-1-git-send-email-surovegin@google.com> <20120301150957.GA13533@redhat.com>
From: Eugene Surovegin <surovegin@google.com>
Date: Thu, 1 Mar 2012 09:04:32 -0800
Message-ID: <CANrfoUVMP5hPfm2R=C9eszS728YccKyWokUAa5Q5KN36+W83bg@mail.gmail.com>
Subject: Re: [PATCH] kdump: force page alignment for per-CPU crash notes.
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        kexec-list <kexec@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 7:09 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Feb 29, 2012 at 09:21:23AM -0800, Eugene Surovegin wrote:
>> Per-CPU allocations are not guaranteed to be physically contiguous.
>> However, kdump kernel and user-space code assumes that per-CPU
>> memory, used for saving CPU registers on crash, is.
>> This can cause corrupted /proc/vmcore in some cases - the main
>> symptom being huge ELF note section.
>>
>> Force page alignment for note_buf_t to ensure that this assumption holds.
>>
>
> Hi Eugene,
>
> Where do we make assumption that crash_notes address is page aligned?

I never said that. I said that assumption was that note chunks were
physically contiguous.

[snip]

> Are you referring to the fact that note could be stored on two different
> physical pages and then kexec-tools does not know about the physical
> address of second page, hence second kernel does not know about it
> and we never read that data. That sounds like a problem.

Yes. This is exactly what happens in some cases.

> So it make sense to force the page size alignment and if notes ever
> grow beyond 1 page, we need to come up with more complex ways of
> communicating more than 1 physical address to second kernel.

Yes. Thankfully notes so far are smaller than a page.
And if they do grow larger, than kexec-tools have to be modified
anyways - currently maximum note size (1K) is hardcoded there.
If this happens, I think instead of coming up with a way to
communicate phys to virt mapping, it'd be easier just to change th way
notes are allocated in the kernel so they are phys contiguous.

--
Eugene
