Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2E2ArL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 20:47:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42553 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2E2ArJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 20:47:09 -0400
Date: Tue, 29 May 2012 01:47:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Drewry <wad@chromium.org>, wade_farnsworth@mentor.com,
        stevenrwalter@gmail.com, will.deacon@arm.com,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: New ARM asm/syscall.h incompatible? (commit
 bf2c9f9866928df60157bc4f1ab39f93a32c754e)
Message-ID: <20120529004700.GR11775@ZenIV.linux.org.uk>
References: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
 <20120523185610.GB6908@n2100.arm.linux.org.uk>
 <CABqD9hah+26ZNJ8OsvSUFSx-dnxekTSLCkUf-8QXQqZ+mn6kmg@mail.gmail.com>
 <20120523191439.GC6908@n2100.arm.linux.org.uk>
 <CABqD9hbsnCL=vHpsE3HNmiB-Qv0DyhWpq5KCN0USWDm8m-6=RA@mail.gmail.com>
 <20120524161130.GE6908@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524161130.GE6908@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 05:11:30PM +0100, Russell King - ARM Linux wrote:
> +__sys_slow:
> +	tst	r10, #_TIF_SECCOMP
> +	beq	__sys_trace
> +
> +	bl	__secure_computing
> +	add	r0, sp, #S_R0 + S_OFF		@ pointer to regs
> +	ldmia	r0, {r0 - r3}
> +
> +	tst	r10, #_TIF_SYSCALL_WORK
> +	beq	__sys_fast

What is it doing outside of syscall_trace(), anyway?
