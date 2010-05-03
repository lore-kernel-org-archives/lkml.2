Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab0ECXd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:33:59 -0400
Received: from p01c11o147.mxlogic.net ([208.65.144.70]:53359 "EHLO
	p01c11o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0ECXd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:33:56 -0400
X-MXL-Hash: 4bdf5d62478c186c-6b91d9292970a75ff66b022d3cb2657f846da1de
X-MXL-Hash: 4bdf5d3d2b0fe969-4a090adc1bbf08c5fb786e9ce7f169327df3aa14
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>, Greg KH <greg@kroah.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>, Greg KH <gregkh@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 3 May 2010 18:33:08 -0500
Subject: RE: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrrCE5z7zo45INoSsK3ajGpL7xinAACMx+QAAFj3EA=
Message-ID: <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
	<20100430215645.GA12409@kroah.com>
	<0D753D10438DA54287A00B0270842697636E9B9B0D@AUSP01VMBX24.collaborationhost.net>
	<20100503185933.GA27346@kroah.com>
	<0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
	<20100503211751.GB21402@kroah.com>
 <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
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
X-SOURCE-IP: [216.166.12.31]
X-AnalysisOut: [v=1.0 c=1 a=n2LqRRw_DHMA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel]
X-AnalysisOut: [0A:10 a=qS3xps/WtSuafY8lc/WARg==:17 a=VwQbUJbxAAAA:8 a=ujF]
X-AnalysisOut: [V0XuX7SQ2zPtO_jcA:9 a=3E58tnxIx3OlK4azlMEA:7 a=7L5ApNuQ1Zn]
X-AnalysisOut: [1g_BJ35bGdgu6d6EA:4 a=CjuIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 03, 2010 3:45 PM, H Hartley Sweeten wrote:
>>> Could the next tree be out of sync with your tree?
>>
>> Hm, some other tree might be doing something in those files.  But the
>> fact that the drivers/staging/dt3155/dt3155_io.h was so wrong it thought
>> it was a revert, makes me suspect that you did it against something
>> else.
>>
>> If you make this against my staging-next tree at
>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>> Using the staging-next branch, does that make the patch different?
>
> Ok.  Pulled your staging-next (thanks Joe).
>
> It's way different from linux-next and matches Linus' tree exactly.  It's
> missing all of your "Drop the "_s"..." and "The typedef is not needed." 
> patches.
>
> Of course I could be on the wrong branch for your staging-next tree.  The
> only branches listed are:
>
> $ git branch -a
> * master
>   remotes/origin/HEAD -> origin/master
>   remotes/origin/master

It appears these are the patches missing in your staging-next tree that do
exist in the linux-next tree:

Staging: dt3155: remove "inline" usage
Staging: dt3155: rename dt3155_fbuffer_s
Staging: dt3155: rename dt3155_config_s
Staging: dt3155: rename dt3155_read_t
Staging: dt3155: rename dt3155_status_t
Staging: dt3155: remove frame_info_t
Staging: dt3155: remove TRUE/FALSE
Staging: dt3155: remove #ifdef
Staging: dt3155: allocator.c: sparse cleanups
Staging: dt3155: fix parentheses and bracket spacing style issues
Staging: dt3155: fix coding style issue in dt3155_isr.c
Staging: dt3155: fix wait_ibsyclr function
Staging: remove unused #include <linux/version.h>

The first one that exists in both is:

Staging: dt3155: fix 50Hz configuration

Could the others be in a staging-stable branch?

Regards,
Hartley