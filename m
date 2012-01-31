Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2AaGb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 01:31:27 -0500
Received: from mail.wdtv.com ([66.118.69.84]:34938 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab2AaGbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 01:31:25 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        emc-users@lists.sourceforge.net
Subject: Re: isolcpus question
Date: Tue, 31 Jan 2012 01:31:19 -0500
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-pclos2.pae.bfs; KDE/4.6.5; i686; ; )
References: <201201302213.39672.gene.heskett@gmail.com> <1327985246.6667.8.camel@marge.simson.net>
In-Reply-To: <1327985246.6667.8.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201201310131.20239.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 30, 2012, Mike Galbraith wrote:
>On Mon, 2012-01-30 at 22:13 -0500, Gene Heskett wrote:
>> Which is, is there a isolcpus troubleshooting tool?
>> 
>> I have an app that is supposed to use the 2nd cpu on a 2 core atom
>> system all by itself, and its insisting on using cpu0 when the boot
>> command line has "isolcpus=1" appended to it, and apparently I am the
>> only one with the problem, its working for about 200-500 others
>> running the same software.
>
>isolcpus=1 isolates CPU1 so no task will automatically end up using it,
>but it's up to your task (or you) to move to the isolated CPU.  Pin your
>task to CPU1 with taskset, and all should work fine.
>
>	-Mike

Cross-posted back to the emc-users list, others might find it useful also.

Mike, you're a genius. The man page for taskset is a bit obtuse but the 
first stab at a '/usr/bin/lcnc' script:
-------------
#!/bin/bash
taskset 0x00000002 emc -l
exit 0
-------------
Seems to launch this application and I believe its now working better than 
ever before.  Now I need to do some experimenting to see just how fast I 
can make linuxcnc's base_thread run without the rest of the box getting 
laggy.  The faster I can make that thread run, the faster and smoother my 
steppers driving my milling machine will run.  I have already cut it down 
to 30 u-secs from 65 u-secs and it is still only using about 26% of the 
target cpu1.  Amazing IMO.

Thank you very much Mike.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene>
When a lion meets another with a louder roar,
the first lion thinks the last a bore.
		-- G.B. Shaw
