Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1LUGpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 01:45:43 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:52456 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1LUGpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 01:45:40 -0500
Date: Wed, 21 Dec 2011 07:45:37 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Florian Mickler <florian@mickler.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 3.2-rc6+: Reported regressions from 3.0 and 3.1
Message-ID: <20111221064537.GD1629@x4>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
 <201112210039.14100.linux-pm-bounces@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112210039.14100.linux-pm-bounces@lists.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.12.21 at 00:54 +0100, Rafael J. Wysocki wrote:
> Subject    : WARNING: at fs/sysfs/sysfs.h:195 (during boot)
> Submitter  : Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
> Date       : 2011-11-13 19:24
> Message-ID : 20111113192417.GA1659-tLCgZGx+iJ+kxVt8IV0GqQ@public.gmane.org
> References : http://marc.info/?l=linux-kernel&m=132121231921932&w=2
> 
> Subject    : WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
> Submitter  : Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
> Date       : 2011-11-18 7:25
> Message-ID : 20111118072519.GA1615-tLCgZGx+iJ+kxVt8IV0GqQ@public.gmane.org
> References : http://marc.info/?l=linux-kernel&m=132160119031794&w=2

Both entries were caused by the same Radeon kexec writeback bug. This issue
will hopefully be fixed in the next release.

> Subject    : Impossible high cpu-time values for migration threads
> Submitter  : Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
> Date       : 2011-11-17 22:17
> Message-ID : 20111117221731.GA9229-tLCgZGx+iJ+kxVt8IV0GqQ@public.gmane.org
> References : http://marc.info/?l=linux-kernel&m=132156832124314&w=2

This is a cosmetic issue, but I'm still seeing this after bursts of high
CPU usage:

 % ps afx -F
UID        PID  PPID  C    SZ   RSS PSR STIME TTY      STAT   TIME CMD
root         2     0  0     0     0   1 Dec20 ?        S      0:00 [kthreadd]
root         3     2  0     0     0   0 Dec20 ?        S      0:01  \_ [ksoftirqd/0]
root         6     2  0     0     0   0 Dec20 ?        S      0:00  \_ [migration/0]
root         7     2  0     0     0   1 Dec20 ?        S      0:00  \_ [migration/1]
root         8     2  0     0     0   1 Dec20 ?        S      0:05  \_ [kworker/1:0]
root         9     2  0     0     0   1 Dec20 ?        S      0:01  \_ [ksoftirqd/1]
root        11     2  0     0     0   2 Dec20 ?        S      0:00  \_ [migration/2]
root        13     2  0     0     0   2 Dec20 ?        S      0:01  \_ [ksoftirqd/2]
root        14     2 22     0     0   3 Dec20 ?        S    192:21  \_ [migration/3]
root        16     2  0     0     0   3 Dec20 ?        S      0:01  \_ [ksoftirqd/3]
root        17     2  0     0     0   2 Dec20 ?        S<     0:00  \_ [khelper]
...

-- 
Markus
