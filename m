Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab0EDNLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:11:12 -0400
Received: from smtp.nokia.com ([192.100.122.233]:16436 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0EDNLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:11:10 -0400
Subject: Re: [PATCHv2] MTD: Suppress warnings in inline_map_read()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1272354388.26036.4.camel@localhost>
References: <1270891582.4704.102.camel@macbook.infradead.org>
	 <e970485f0e9f4c9e1cb6e594a45dd11308683197@localhost.localdomain>
	 <1272354388.26036.4.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 16:04:32 +0300
Message-ID: <1272978272.3702.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 May 2010 13:10:34.0125 (UTC) FILETIME=[2E2E53D0:01CAEB8B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 10:46 +0300, Artem Bityutskiy wrote:
> On Sat, 2010-04-10 at 11:18 -0700, Kevin Cernekee wrote:
> > With gcc 4.4.3 -O2 on MIPS32:
> > 
> > drivers/mtd/chips/cfi_util.c: In function 'cfi_qry_present':
> > include/linux/mtd/map.h:390: warning: 'r' may be used uninitialized in this function
> > include/linux/mtd/map.h:375: note: 'r' was declared here
> > include/linux/mtd/map.h:390: warning: 'r' may be used uninitialized in this function
> > include/linux/mtd/map.h:375: note: 'r' was declared here
> > 
> > Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
> 
> Pushed to l2-mtd-2.6 / dunno

Removed from my tree because this breaks compilation:

[dedekind@eru l2-mtd-2.6]$ make  ARCH=arm O=/home/dedekind/tmp/l2-mtd-2.6-arm/
  Using /home/dedekind/git/l2-mtd-2.6 as source for kernel
  GEN     /home/dedekind/tmp/l2-mtd-2.6-arm/Makefile
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
make[2]: `include/generated/mach-types.h' is up to date.
  CALL    /home/dedekind/git/l2-mtd-2.6/scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC [M]  drivers/mtd/lpddr/lpddr_cmds.o
In file included from /home/dedekind/git/l2-mtd-2.6/include/linux/mtd/qinfo.h:4,
                 from /home/dedekind/git/l2-mtd-2.6/include/linux/mtd/pfow.h:7,
                 from /home/dedekind/git/l2-mtd-2.6/drivers/mtd/lpddr/lpddr_cmds.c:27:
/home/dedekind/git/l2-mtd-2.6/include/linux/mtd/map.h: In function 'inline_map_read':
/home/dedekind/git/l2-mtd-2.6/include/linux/mtd/map.h:390: error: implicit declaration of function 'BUG'
make[4]: *** [drivers/mtd/lpddr/lpddr_cmds.o] Error 1
make[3]: *** [drivers/mtd/lpddr] Error 2
make[2]: *** [drivers/mtd] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2
[dedekind@eru l2-mtd-2.6]$ git revert ae60e258dda8a9c575fcbd68f05ca034ad043a36^C
[dedekind@eru l2-mtd-2.6]$ git log 

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

