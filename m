Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1I0UDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:03:17 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:29594 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752084Ab1I0UDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:03:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uxbXhhEVM1k0YALV.ufdAI87HDjpIra6aqXpYnOpyk3zsjK
 ztWbhsT8oUR7.9wdQBD1muDyLw8DvRtNEZezX7n1MrOWsh2RSPl5V2V1kSBP
 8kGNRY2GwkTknXN3tuBznmE2KS5C8Ooqf5v.dBLm3v6yY0BI1dLyW_OMvc8F
 fwc57TbqCnSZ.RQ.bG7KlJcwPMolC8EmPJE5f8P1IO8o5F57gSskzoeVU53_
 0hj1sOchrMwX1evoiN7FOXIpSJP3PcNikLddlcMAnuq3nBB0MsbiuOQXilUe
 GCHM0SL756HE9T7KDcNN1IpIQpQmmon0YeOc2tJFxAfoq3WyHa0IVsr8yl2r
 P9XKkqlSBhFZJ3iCCGLv7rs0xcoCIZmqu231t3WpVCb723xmLIf3H1b9d3Ht
 Lr57psKftchK4JUb5r_FTIgc-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Sep 2011 15:03:09 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Vasiliy Kulikov <segoon@openwall.com>
cc: kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
In-Reply-To: <20110927193810.GA5416@albatros>
Message-ID: <alpine.DEB.2.00.1109271459180.13797@router.home>
References: <20110927175453.GA3393@albatros> <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Vasiliy Kulikov wrote:

> On Tue, Sep 27, 2011 at 21:56 +0400, Vasiliy Kulikov wrote:
> > /proc/meminfo stores information related to memory pages usage, which
> > may be used to monitor the number of objects in specific caches (and/or
> > the changes of these numbers).  This might reveal private information
> > similar to /proc/slabinfo infoleaks.  To remove the infoleak, just
> > restrict meminfo to root.  If it is used by unprivileged daemons,
> > meminfo permissions can be altered the same way as slabinfo:
> >
> >     groupadd meminfo
> >     usermod -a -G meminfo $MONITOR_USER
> >     chmod g+r /proc/meminfo
> >     chgrp meminfo /proc/meminfo
>
> Just to make it clear: since this patch breaks "free", I don't propose
> it anymore.

Viewing free memory is usually necessary to check on reclaim activities
(things otherwise operating normally). "free" memory (in the sense of the
memory that an application can still allocate) is not really displayed by
free. Wish we had a new free that avoids all the misinterpretations.

Meminfo is also requires by vmstat.

If we want to go down this route then we need some sort of diagnostic
group that a user must be part of in order to allow viewing of basic
memory statistics.
