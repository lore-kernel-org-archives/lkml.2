Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab0ECWq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:46:58 -0400
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:36516 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab0ECWq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:46:57 -0400
X-MXL-Hash: 4bdf526145155ea4-71875ef1590323fc29c95fae73e27d3df721607a
X-MXL-Hash: 4bdf525046195d0c-26ccbc01634be190f368aac3e43ad0f4e8088713
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Greg KH <greg@kroah.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Greg KH <gregkh@suse.de>, "ss@aao.gov.au" <ss@aao.gov.au>
Date: Mon, 3 May 2010 17:45:28 -0500
Subject: RE: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrrCE5z7zo45INoSsK3ajGpL7xinAACMx+Q
Message-ID: <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
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
X-SOURCE-IP: [216.166.12.69]
X-AnalysisOut: [v=1.0 c=1 a=n2LqRRw_DHMA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=TYbMNos9eHUa9bm6/o8foQ==:17 a=rOUgymgbAAAA:8 a=VwQ]
X-AnalysisOut: [bUJbxAAAA:8 a=jEWyFRgDIKRhgqFlRRIA:9 a=CxgNY-PXgWqhOTvT1E5]
X-AnalysisOut: [W_ZRiD8wA:4 a=CjuIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 03, 2010 2:18 PM, Greg KH wrote:
>>> Did you rebase this on the latest linux-next tree?
>> 
>> I did.  And I just re-did is again against next-20100503 and it generated the same patch.
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
>
> If you make this against my staging-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> U sing the staging-next branch, does that make the patch different?

Ok.  Pulled your staging-next (thanks Joe).

It's way different from linux-next and matches Linus' tree exactly.  It's
missing all of your "Drop the "_s"..." and "The typedef is not needed." 
patches.

Of course I could be on the wrong branch for your staging-next tree.  The
only branches listed are:

$ git branch -a
* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/master

Regards,
Hartley