Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900Ab1CaKRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:17:03 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:44388 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933887Ab1CaKRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:17:00 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Thomas Gleixner'" <tglx@linutronix.de>
Cc: "'Paul Mundt'" <lethal@linux-sh.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
References: <01eb01cbeeb7$30390460$90ab0d20$@mprc.pku.edu.cn> <201103301417.20027.arnd@arndb.de> <alpine.LFD.2.00.1103301421390.22418@localhost6.localdomain6> <201103301440.03479.arnd@arndb.de>
In-Reply-To: <201103301440.03479.arnd@arndb.de>
Subject: RE: [PATCH] unicore32 fix: remove arch-specific futex support
Date: Thu, 31 Mar 2011 18:16:20 +0800
Message-ID: <004301cbef8c$b0bf0640$123d12c0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQKI+b6m1CyJqXYj5hUyo+RnqBvTZgGkwykXAp/ha8wBh0wlqpKexHwg
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Wednesday, March 30, 2011 8:40 PM
> To: Thomas Gleixner
> Cc: Guan Xuetao; Paul Mundt; linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org
> Subject: Re: [PATCH] unicore32 fix: remove arch-specific futex support
> 
> On Wednesday 30 March 2011, Thomas Gleixner wrote:
> > The problem is that you need cmpxchg in user space as well.
> >
> > ARM does this with some syscall magic for machines which do not have
> > cmpxchg.
> 
> Ah, right. I wonder how sh does it.
> 
> I also remember that the original unicore32 ABI had support for a cmpxchg
> system call, but that was removed with the move to the generic syscall
> table.
> 
> It is of course possible to add it back using the __NR_arch_specific_syscall
> entry point.
> 
> 	Arnd

For cmpxchg, we have both system call and kuser_cmpxchg supports in old abi
which are similar to arm.
The performance of system call version is too poor,  so it could be only used for test.

Thanks & Regards

Guan Xuetao

