Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906Ab2EWTPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:15:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48850 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028Ab2EWTPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:15:19 -0400
Date: Wed, 23 May 2012 20:14:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Drewry <wad@chromium.org>
Cc: wade_farnsworth@mentor.com, stevenrwalter@gmail.com, will.deacon@arm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: New ARM asm/syscall.h incompatible? (commit
	bf2c9f9866928df60157bc4f1ab39f93a32c754e)
Message-ID: <20120523191439.GC6908@n2100.arm.linux.org.uk>
References: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com> <20120523185610.GB6908@n2100.arm.linux.org.uk> <CABqD9hah+26ZNJ8OsvSUFSx-dnxekTSLCkUf-8QXQqZ+mn6kmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqD9hah+26ZNJ8OsvSUFSx-dnxekTSLCkUf-8QXQqZ+mn6kmg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 02:04:20PM -0500, Will Drewry wrote:
> I'm still curious if it wouldn't make more sense to handle the
> sys_syscall special case prior to any cross-arch (slowpath) code
> involvement rather than truncating the 7th parameter making
> sys_syscall a second class citizen for those cross-arch paths.

It would mean making sys_syscall an explicit special case in the fast
path of syscall entry, which we really don't want to do.  It _is_ a
standard syscall, it just happens to have 7 arguments which are
rewritten back to what the syscall actually expects.

As I say, the alternative would be to explicitly test for the syscall
number in the fast path of system call entry and branch away to deal
with it.  Adding unnecessary instructions to this fast path for such
a special case when there's already a perfectly reasonable alternative
solution doesn't fill me with any joy.
