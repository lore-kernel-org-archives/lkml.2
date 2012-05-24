Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2EXS6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:58:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35397 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab2EXS6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:58:37 -0400
MIME-Version: 1.0
In-Reply-To: <CABqD9hbops5d-panvjYJ_4Q52P2T2_Ecz+50_BS8xyaQS7uUkg@mail.gmail.com>
References: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
 <20120523164503.GG26693@mudshark.cambridge.arm.com> <CABqD9hbops5d-panvjYJ_4Q52P2T2_Ecz+50_BS8xyaQS7uUkg@mail.gmail.com>
From: Roland McGrath <mcgrathr@google.com>
Date: Thu, 24 May 2012 11:58:15 -0700
Message-ID: <CAB=4xhoZ9eBtZ8xJfOAiRCN9WxOkBM=1w8Q9GQAA7L3XDrBWZg@mail.gmail.com>
Subject: Re: New ARM asm/syscall.h incompatible? (commit bf2c9f9866928df60157bc4f1ab39f93a32c754e)
To: Will Drewry <wad@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "wade_farnsworth@mentor.com" <wade_farnsworth@mentor.com>,
        "stevenrwalter@gmail.com" <stevenrwalter@gmail.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I first added the asm/syscall.h interface, I took six arguments
to be a universal limit
in the kernel.  I had the impression that the limit was encoded in
many places, but I really
don't recall any details now.  For x86-32, it is a hard limit of the
register argument passing
convention, as six arguments plus syscall number and stack pointer is
all the registers there are.
So no generic syscall will ever have more than six arguments, since
x86-32 couldn't support it.

If there are machine-specific syscalls that allow more arguments, then
I think it would be reasonable
to make a machine-specfiic argument limit part of the asm/syscall.h
interface.  That is, define some
macro like MAX_SYSCALL_ARGS in asm/syscall.h.  If you do that, please
put a definition for it in
asm-generic/syscall.h and update the kerneldoc comments there to
mention that macro instead of
the explicit "6" and "0..5" there now.


Thanks,
Roland
