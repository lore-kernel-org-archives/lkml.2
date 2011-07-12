Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab1GLOE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 10:04:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab1GLOE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 10:04:57 -0400
Message-ID: <4E1C5487.9030405@suse.cz>
Date: Tue, 12 Jul 2011 16:04:55 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: `make headers_check' bustage
References: <20110707171627.4f15035e.akpm@linux-foundation.org>
In-Reply-To: <20110707171627.4f15035e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.7.2011 02:16, Andrew Morton wrote:
> It is just me, or is headers_check busted in current -linus?
>
> z:/usr/src/25>  make mrproper; make allmodconfig; make headers_check
> ...
> /usr/src/25/usr/include/linux/kernel.h:65: userspace cannot reference function or variable defined in the kernel

Introduced by 7ef88ad5 (BUILD_BUG_ON: make it handle more cases), the 
whole BUILD_BUG_ON stuff should be hidden behind #ifdef __KERNEL__, but 
it's pretty harmless.


> /usr/src/25/usr/include/linux/quota.h:175: userspace cannot reference function or variable defined in the kernel

That's actualy a false positive, the header defines a prototype for the 
quotactl() syscall.


> /usr/src/25/usr/include/linux/sdla.h:116: userspace cannot reference function or variable defined in the kernel

That looks indeed bogus, there is no sdla() syscall.


> /usr/src/25/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel

As Vitaliy wrote, this is a leftover after 43a9907.

Nevertheless, these errors are pretty harmless, the prototypes do not 
break parsing the header when compiling userspace programs.

Michal
