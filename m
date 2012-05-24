Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab2EXPjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:39:43 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36832 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761Ab2EXPjm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:39:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120523191439.GC6908@n2100.arm.linux.org.uk>
References: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
	<20120523185610.GB6908@n2100.arm.linux.org.uk>
	<CABqD9hah+26ZNJ8OsvSUFSx-dnxekTSLCkUf-8QXQqZ+mn6kmg@mail.gmail.com>
	<20120523191439.GC6908@n2100.arm.linux.org.uk>
Date: Thu, 24 May 2012 10:39:38 -0500
Message-ID: <CABqD9hbsnCL=vHpsE3HNmiB-Qv0DyhWpq5KCN0USWDm8m-6=RA@mail.gmail.com>
Subject: Re: New ARM asm/syscall.h incompatible? (commit bf2c9f9866928df60157bc4f1ab39f93a32c754e)
From: Will Drewry <wad@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: wade_farnsworth@mentor.com, stevenrwalter@gmail.com, will.deacon@arm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 2:14 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, May 23, 2012 at 02:04:20PM -0500, Will Drewry wrote:
>> I'm still curious if it wouldn't make more sense to handle the
>> sys_syscall special case prior to any cross-arch (slowpath) code
>> involvement rather than truncating the 7th parameter making
>> sys_syscall a second class citizen for those cross-arch paths.
>
> It would mean making sys_syscall an explicit special case in the fast
> path of syscall entry, which we really don't want to do.  It _is_ a
> standard syscall, it just happens to have 7 arguments which are
> rewritten back to what the syscall actually expects.
>
> As I say, the alternative would be to explicitly test for the syscall
> number in the fast path of system call entry and branch away to deal
> with it.  Adding unnecessary instructions to this fast path for such
> a special case when there's already a perfectly reasonable alternative
> solution doesn't fill me with any joy.

I'd been picturing this as being done exclusively after the slow-path
is triggered, in __sys_trace or syscall_trace(), but perhaps I'm
missing something that makes that untenable.

thanks!
will
