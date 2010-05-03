Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab0ECWZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:25:08 -0400
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:47410 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758965Ab0ECWZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:25:05 -0400
X-MXL-Hash: 4bdf4d4127ae29b1-ce167d02cb6dcd30bfdb44ccff72a97ab17e605e
X-MXL-Hash: 4bdf4d3f162755a6-fc88e719b00064e1108d5f446d4f776924e678a6
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Greg KH <gregkh@suse.de>, "ss@aao.gov.au" <ss@aao.gov.au>
Date: Mon, 3 May 2010 17:24:35 -0500
Subject: RE: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrrCE5z7zo45INoSsK3ajGpL7xinAABimJQ
Message-ID: <0D753D10438DA54287A00B0270842697636EADE191@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
 <20100430215645.GA12409@kroah.com>
 <0D753D10438DA54287A00B0270842697636E9B9B0D@AUSP01VMBX24.collaborationhost.net>
 <20100503185933.GA27346@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
 <20100503211751.GB21402@kroah.com>
In-Reply-To: <20100503211751.GB21402@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010042901)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.99]
X-AnalysisOut: [v=1.0 c=1 a=n2LqRRw_DHMA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=rOUgymgbAAAA:8 a=VwQ]
X-AnalysisOut: [bUJbxAAAA:8 a=AinsULg4O2LQTOKhP-cA:9 a=eXGidEREitBPH2IGBfs]
X-AnalysisOut: [joCXieVcA:4 a=CjuIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 03, 2010 2:18 PM, Greg KH wrote:
>>> Did you rebase this on the latest linux-next tree?
>> 
>> I did.  And I just re-did is again against next-20100503 and it generated
>> the same patch.
>
> Wierd.
>
>> But, I just noticed this:
>> 
>> $ git log drivers/staging/dt3155
>> commit 3c59b4691587b8977cc77ecf07985758a2ba0d97
>> Merge: 7f1e428 bed46a8
>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date:   Mon May 3 14:17:49 2010 +1000
>> 
>>     Merge remote branch 'staging-next/staging-next'
>>     
>>     Conflicts:
>>         drivers/staging/arlan/arlan-main.c
>>         drivers/staging/comedi/drivers/cb_das16_cs.c
>>         drivers/staging/cx25821/cx25821-alsa.c
>>         drivers/staging/dt3155/dt3155_drv.c
>>         drivers/staging/netwave/netwave_cs.c
>> 
>> Could the next tree be out of sync with your tree?
>
> Hm, some other tree might be doing something in those files.  But the
> fact that the drivers/staging/dt3155/dt3155_io.h was so wrong it thought
> it was a revert, makes me suspect that you did it against something
> else.

I just looked at the Next/merge.log file for next-20100503.

$ git merge origin/master
...
 drivers/staging/dt3155/dt3155_drv.c               |    4 +-
...
$ git merge staging-next/staging-next
...
Resolved 'drivers/staging/dt3155/dt3155_drv.c' using previous resolution.
...
Auto-merging drivers/staging/dt3155/dt3155_drv.c
CONFLICT (content): Merge conflict in drivers/staging/dt3155/dt3155_drv.c
...
$ git diff -M --stat --summary HEAD^..
...
 drivers/staging/dt3155/allocator.c                 |   16 +-
 drivers/staging/dt3155/allocator.h                 |    4 +-
 drivers/staging/dt3155/dt3155.h                    |   44 +-
 drivers/staging/dt3155/dt3155_drv.c                |  380 +-
 drivers/staging/dt3155/dt3155_io.c                 |   24 +-
 drivers/staging/dt3155/dt3155_isr.c                |  297 +-
 drivers/staging/dt3155/dt3155_isr.h                |    2 +-
...

Not sure if that helps...

>
> If you make this against my staging-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> using the staging-next branch, does that make the patch different?
>
> Let me know if you need help doing that.

I just tried pulling that tree and got:

$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
fatal: Not a git repository (or any of the parent directories): .git

So, yes I need help doing that ;-)

Regards,
Hartley