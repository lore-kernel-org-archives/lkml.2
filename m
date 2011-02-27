Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab1B0DV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 22:21:28 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:54018 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1B0DVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 22:21:25 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <014b01cbcdad$f110afb0$d3320f10$@mprc.pku.edu.cn> <201102171845.01177.arnd@arndb.de>
In-Reply-To: <201102171845.01177.arnd@arndb.de>
Subject: RE: [PATCH 05/12] unicore32 additional architecture files: low-level lib: uaccess
Date: Sun, 27 Feb 2011 11:21:12 +0800
Message-ID: <017b01cbd62d$633fd070$29bf7150$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJUJ5R0byzuScHkceok2M2VIwxC3QHwN80AkvSHNnA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 18, 2011 1:45 AM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCH 05/12] unicore32 additional architecture files: low-level lib: uaccess
> 
> On Wednesday 16 February 2011, Guan Xuetao wrote:
> > +
> > +#define __kernel_ok		(segment_eq(get_fs(), KERNEL_DS))
> > +#define __user_ok(addr, size)	(((size) <= TASK_SIZE)			\
> > +				&& ((addr) <= TASK_SIZE - (size)))
> > +#define __access_ok(addr, size)	(__kernel_ok || __user_ok((addr), (size)))
> 
> A nice trick to simplify this is to introduce a per-process variable for comparing
> the pointer, set_fs() then sets this variable to either TASK_SIZE or
> UINT_MAX.

Perhaps like this:
1. add a member named kaddr in thread_info
2. add following assignment codes in set_fs:
        current_thread_info()->kaddr =  segment_eq(fs, KERNEL_DS) ? UINT_MAX : TASK_SIZE;
3. then __access_ok will be:
        #define addr 
        #define __access_ok(addr, size)   (((size) <= TASK_SIZE)			\
				&& ((addr) <= current_thread_info()->kaddr)  - (size)))

> 
> This saves one conditional branch for each call to __access_ok.
> 
> 	Arnd

