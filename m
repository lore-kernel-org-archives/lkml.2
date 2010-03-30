Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab0C3HpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 03:45:10 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:53503 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904Ab0C3HpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 03:45:06 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-05.arcor-online.net 3673B332A40
Subject: Re: [Bug 12309] Large I/O operations result in slow performance
 and high iowait times
From: Thomas Pilarski <Thomas.Pilarski@arcor.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <201003162357.o2GNvkNF024562@demeter.kernel.org>
References: <bug-12309-14043@http.bugzilla.kernel.org/>
	 <201003162357.o2GNvkNF024562@demeter.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 09:44:54 +0200
Message-ID: <1269935094.2481.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late answer. 

There is regression in desktop responsiveness from 2.6.32 to 2.6.33. I
am working on a notebook with a full encrypted lvm partition. The
throughput of the disk is about 70MB/s in the outer regions. There is
another hard disk in an ultra bay slot. 

While 2.6.32 is "usable", the 2.6.33 freezes for up to two minutes in a
30 seconds interval while tracker starts to index a new inserted hard
disk with a lot of small files (openembedded build tree). This starts
with a wrong configured tracker and the 2.6.32 kernel with freezes up to
10 seconds.

The indexed ultrabay dics is not encrypted and formated with ext4, only
the indexes are writen on an ext3 partition in an ecrypted logical
volume group, which also contains the system partition.

This problem is enormous increased, while the ultra bay disc is acceded
with udma2 instead of udma6 (caused by another bug), 

I can execute some tests, but you should tell me, which results you need
to identify the problem.

Thomas Pilarski


Am Dienstag, den 16.03.2010, 23:57 +0000 schrieb
bugzilla-daemon@bugzilla.kernel.org: 
> http://bugzilla.kernel.org/show_bug.cgi?id=12309
> 
> --- Comment #420 from Andrew Morton <akpm@linux-foundation.org>  2010-03-16 23:56:58 ---
> (In reply to comment #419)
> > I am currently using the linux kernel 2.6.33 and the the desktop responsiveness
> > is awful on my machine compared to the 2.6.32.x kernel. It's even worse than I
> > have even seen it before. The load avg is rising to >7 very quickly, while
> > writing many small file to the filesystem. I can make some tests with my
> > configuration, but a kernel developer should tell me which tests.
> 
> This isn't really the best place to bring this up.  Please send a full
> description to linux-kernel@vger.kernel.org.  cc myself, Ingo Molnar
> <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jens Axboe
> <jens.axboe@oracle.com>.  In that email, please identify what the system is
> doing at the time.  Is it disk-related?  CPU scheduler related?  etc.
> 
> Thanks.
> 




