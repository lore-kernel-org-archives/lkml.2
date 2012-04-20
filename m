Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2DTXAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:00:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2DTXAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:00:41 -0400
Date: Fri, 20 Apr 2012 16:00:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] init: make sure syscall arguments are marked
 __user where needed
Message-Id: <20120420160039.74c49a0c.akpm@linux-foundation.org>
In-Reply-To: <201204161733.23830.hartleys@visionengravers.com>
References: <201204161733.23830.hartleys@visionengravers.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 17:33:23 -0700
H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> When using syscall routines in the kernel, some of the arguments
> should be user pointers but are missing the __user markup. This
> produces a number of sparse warnings of the format:    
>   
> warning: incorrect type in argument 1 (different address spaces)
>    expected char [noderef] <asn:1>*dev_name
>    got char *name 
> 
> Wrap the syscall routines in the private do_mounts.h header so that
> the appropriate __user markups are added for the init mount code.

This makes rather a mess of do_mounts.c for pretty marginal benefit.

Can we just make "make C=1" skip that file or something?
