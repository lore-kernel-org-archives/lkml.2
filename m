Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2BVRMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:12:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab2BVRMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:12:24 -0500
Date: Wed, 22 Feb 2012 18:12:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] thp: 'transparent_hugepage=' can also be specified on
 cmdline
In-Reply-To: <20120222170315.GJ10222@redhat.com>
Message-ID: <alpine.LNX.2.00.1202221811380.31150@pobox.suse.cz>
References: <alpine.LNX.2.00.1202221710050.31150@pobox.suse.cz> <20120222170315.GJ10222@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Feb 2012, Andrea Arcangeli wrote:

> > diff --git a/Documentation/vm/transhuge.txt b/Documentation/vm/transhuge.txt
> > index 29bdf62..4a3816d 100644
> > --- a/Documentation/vm/transhuge.txt
> > +++ b/Documentation/vm/transhuge.txt
> > @@ -103,6 +103,9 @@ echo always >/sys/kernel/mm/transparent_hugepage/enabled
> >  echo madvise >/sys/kernel/mm/transparent_hugepage/enabled
> >  echo never >/sys/kernel/mm/transparent_hugepage/enabled
> >  
> > +The always/madvise/never value can also be specified on the kernel boot
> > +commandline using 'transparent_hugepage=' parameter.
> > +
> >  It's also possible to limit defrag efforts in the VM to generate
> 
> This is a dup.

I am blind and you are right.

v2 below. Thanks.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] thp: 'transparent_hugepage=' can also be specified on cmdline

Behavior of THP can either be toggled through sysfs in runtime or using a 
kernel cmdline parameter 'transparent_hugepage='. Document the latter in 
kernel-parameters.txt

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 033d4e6..a4de9b9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2629,6 +2629,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			to facilitate early boot debugging.
 			See also Documentation/trace/events.txt
 
+	transparent_hugepage=
+			[KNL]
+			Format: [always|madvise|never]
+			Can be used to control the default behavior of the system
+			with respect to transparent hugepages.
+			See Documentation/vm/transhuge.txt for more details.
+
 	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this

-- 
Jiri Kosina
SUSE Labs
