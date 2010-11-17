Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935438Ab0KQWH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:07:28 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:16727 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934863Ab0KQWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:07:27 -0500
Date: Wed, 17 Nov 2010 14:05:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: BKL: remove extraneous #include <smp_lock.h>
Message-Id: <20101117140526.d532b373.randy.dunlap@oracle.com>
In-Reply-To: <201011172159.oAHLx1tu001236@hera.kernel.org>
References: <201011172159.oAHLx1tu001236@hera.kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 21:59:01 GMT Linux Kernel Mailing List wrote:

> Gitweb:     http://git.kernel.org/linus/451a3c24b0135bce54542009b5fde43846c7cf67
> Commit:     451a3c24b0135bce54542009b5fde43846c7cf67
> Parent:     55f6561c6941713ab5ae9180525b026dd40b7d14
> Author:     Arnd Bergmann <arnd@arndb.de>
> AuthorDate: Wed Nov 17 16:26:55 2010 +0100
> Committer:  Linus Torvalds <torvalds@linux-foundation.org>
> CommitDate: Wed Nov 17 08:59:32 2010 -0800
> 
>     BKL: remove extraneous #include <smp_lock.h>
>     
>     The big kernel lock has been removed from all these files at some point,
>     leaving only the #include.
>     
>     Remove this too as a cleanup.
>     
>     Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---



causes build errors in linux-next of NOV. 17.

see http://lkml.org/lkml/2010/11/17/339
and http://lkml.org/lkml/2010/11/17/365


smp_lock.h was removed from hardirq.h.  smp_lock.h provided the function prototype
for kernel_locked().  Should source files now #include <linux/smp_lock.h> ?
even when not being built for SMP?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
