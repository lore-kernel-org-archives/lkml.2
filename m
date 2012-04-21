Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2DUAmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:42:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2DUAmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:42:03 -0400
Date: Fri, 20 Apr 2012 17:43:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] init: make sure syscall arguments are marked
 __user where needed
Message-Id: <20120420174319.6cea0e81.akpm@linux-foundation.org>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F002069887E112@AUSP01VMBX24.collaborationhost.net>
References: <201204161733.23830.hartleys@visionengravers.com>
	<20120420160039.74c49a0c.akpm@linux-foundation.org>
	<ADE657CA350FB648AAC2C43247A983F002069887E112@AUSP01VMBX24.collaborationhost.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 19:05:46 -0500 H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> > Can we just make "make C=1" skip that file or something?
> 
> What about putting something like this at the top of the files:
> 
> 
> /*
>  * Many of the syscalls used in this file expect some of the arguments
>  * to be __user pointers not __kernel pointers.  To limit the sparse
>  * noise, turn off sparse checking for this file.
>  */
> #ifdef __CHECKER__
> #undef __CHECKER__
> #warning "Sparse checking disabled for this file"
> #endif
> 
> 
> Maybe without the warning if it doesn't seem necessary.
> 
> This keeps <linux/compiler.h> from defining the __attribute__* checks.

That looks nice and explicit.
