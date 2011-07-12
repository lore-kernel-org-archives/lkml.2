Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1GLQCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:02:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654Ab1GLQCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:02:08 -0400
Date: Tue, 12 Jul 2011 09:01:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: `make headers_check' bustage
Message-Id: <20110712090156.c051d864.akpm@linux-foundation.org>
In-Reply-To: <4E1C5487.9030405@suse.cz>
References: <20110707171627.4f15035e.akpm@linux-foundation.org>
	<4E1C5487.9030405@suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 16:04:55 +0200 Michal Marek <mmarek@suse.cz> wrote:

> On 8.7.2011 02:16, Andrew Morton wrote:
> > It is just me, or is headers_check busted in current -linus?
> >
> > z:/usr/src/25>  make mrproper; make allmodconfig; make headers_check
> > ...
> > /usr/src/25/usr/include/linux/kernel.h:65: userspace cannot reference function or variable defined in the kernel
> 
> Introduced by 7ef88ad5 (BUILD_BUG_ON: make it handle more cases), the 
> whole BUILD_BUG_ON stuff should be hidden behind #ifdef __KERNEL__, but 
> it's pretty harmless.
> 
> 
> > /usr/src/25/usr/include/linux/quota.h:175: userspace cannot reference function or variable defined in the kernel
> 
> That's actualy a false positive, the header defines a prototype for the 
> quotactl() syscall.
> 
> 
> > /usr/src/25/usr/include/linux/sdla.h:116: userspace cannot reference function or variable defined in the kernel
> 
> That looks indeed bogus, there is no sdla() syscall.
> 
> 
> > /usr/src/25/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel
> 
> As Vitaliy wrote, this is a leftover after 43a9907.
> 
> Nevertheless, these errors are pretty harmless, the prototypes do not 
> break parsing the header when compiling userspace programs.

Well, it's a bit harmful - someone did an exit(non-zero) and `make'
terminates the build with a build error.
