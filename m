Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1F0QUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:20:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60574 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1F0QUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:20:19 -0400
Date: Mon, 27 Jun 2011 09:20:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Prateek Sharma <prateek3.14@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.0-rc4 - fail to compile...
Message-Id: <20110627092004.92495c82.randy.dunlap@oracle.com>
In-Reply-To: <BANLkTi=eVDsTy0nU5nuiDC+SDe_rhCt3qg@mail.gmail.com>
References: <BANLkTin+pn=WSegcW7cnHk4=76wHkaHPCw@mail.gmail.com>
	<BANLkTi=eVDsTy0nU5nuiDC+SDe_rhCt3qg@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4E08ADC0.0037:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 21:25:55 +0530 Prateek Sharma wrote:

> Will this issue be be please fixed in rc5 ? Not being able to even
> compile it is a big hindrance.

I asked Andrew to merge the patch for this but I haven't seen any email
from him recently, so maybe someone else needs to merge the patch.

http://marc.info/?l=linux-mm&m=130827204306775&w=2

Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>



> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paul Rolland (???・???)
> >
> > Sent: Tuesday, June 21, 2011 3:14 PM
> > To: Linus Torvalds
> > Cc: Linux Kernel Mailing List; rol@witbe.net
> > Subject: Re: Linux 3.0-rc4 - fail to compile...
> > Hello,
> >
> > On Mon, 20 Jun 2011 21:02:56 -0700
> >
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > > Mostly the usual small driver one- (or few-) liners, and some bigger
> > > changes to drm (and md). But also two new smallish drivers
> >
> > > (net/usb/kalmia.c, and the ADP8870 backlight driver). Some filesystem
> > > fixes (btrfs, cifs, afs, xfs, nfsd).
> >
> > This is failing to compile on my machine :
> > ...
> >   CC      mm/page_cgroup.o
> >   CC      fs/direct-io.o
> >
> > mm/page_cgroup.c: In function ‘page_cgroup_init’:
> > mm/page_cgroup.c:308: error: implicit declaration of function ‘node_start_pfn’
> > mm/page_cgroup.c:309: error: implicit declaration of function ‘node_end_pfn’
> > make[1]: *** [mm/page_cgroup.o] Error 1
> >
> > make: *** [mm] Error 2
> > make: *** Waiting for unfinished jobs....
> >   CC      fs/mpage.o
> >   CC      fs/ioprio.o
> > This seems to be caused by arch/x86/include/asm/mmzone_64.h which only defines
> > node_start_pfn and node_end_pfn if CONFIG_NUMA is set.
> >
> >
> > Adding CONFIG_NUMA to my .config fixes the issue.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
