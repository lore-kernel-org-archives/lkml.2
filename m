Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646Ab0EDUD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:03:29 -0400
Received: from p01c12o142.mxlogic.net ([208.65.145.65]:35790 "EHLO
	p01c12o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933575Ab0EDUD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:03:28 -0400
X-MXL-Hash: 4be07d901d4a122c-42fe53f4ea75f64bf7e7b6f5d5b8bc424c026fd7
X-MXL-Hash: 4be07d7a5fbe4df0-79d31e8742e77492b2966f20e7023482171e7271
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Joe Perches <joe@perches.com>, Greg KH <gregkh@suse.de>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 4 May 2010 15:02:35 -0500
Subject: RE: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Topic: Staging: dt3155: Cleanup memory mapped i/o access
Thread-Index: AcrrvQa4epg0g5CnQTGGNP/rx/m35gABw5Pg
Message-ID: <0D753D10438DA54287A00B0270842697636EB83CE8@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
	 <20100430215645.GA12409@kroah.com>
	 <0D753D10438DA54287A00B0270842697636E9B9B0D@AUSP01VMBX24.collaborationhost.net>
	 <20100503185933.GA27346@kroah.com>
	 <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
	 <20100503211751.GB21402@kroah.com>
	 <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
	 <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
	 <20100503234123.GC13519@suse.de>
	 <1272931198.30040.218.camel@Joe-Laptop.home>
	 <20100504025430.GA26421@suse.de> <1273000031.4143.56.camel@Joe-Laptop.home>
In-Reply-To: <1273000031.4143.56.camel@Joe-Laptop.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010043001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.180]
X-AnalysisOut: [v=1.0 c=1 a=n2LqRRw_DHMA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=VwQbUJbxAAAA:8 a=rOU]
X-AnalysisOut: [gymgbAAAA:8 a=1rwW8XS1GhQ00TZLVi4A:9 a=so3p0GMzQU0zMlSgJXL]
X-AnalysisOut: [CoUUKi-oA:4 a=QEXdDO2ut3YA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o44K3ZmE025475

On Tuesday, May 04, 2010 12:07 PM, Joe Perches wrote:
> On Mon, 2010-05-03 at 19:54 -0700, Greg KH wrote: 
>>> git push?
>> I have, and they look to be there to me:
>>   http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-next-2.6.git;a=commit;h=4f923d004396ef272600d381a365cac9d832486d
>> So something must be odd on your side.
>
> Yup, sorry, my mistake.
>
> staging-next is the name of your repository as well as
> a branch within your repository and git after git clone
> doesn't by default show all remote branches.
>
> $ git clone --reference=linux-2.6 \
>	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>
> $ git branch -r
>   origin/HEAD -> origin/master
>   origin/master
>   origin/staging-next
>
> I needed to add a git checkout origin/staging-next

That tree is still missing a couple commits that are in Linus' tree:

commit 6536560cabab170ed2969b005bf69a496e9c45bf
    Staging: dt3155: fix 50Hz configuration

commit 74a920139a0f1119c5a604cef0ce5d6f591dc782
    staging: fix dt3155 build


Which would probably explain the conflict that occurs in linux-next for
dt3155_drv.c.


commit 9e1bd9a6f8c6ad8b461294a365c49b19212178d9
Merge: 5382319 e595eea
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue May 4 15:42:20 2010 +1000

    Merge remote branch 'staging-next/staging-next'
    
    Conflicts:
        drivers/staging/arlan/arlan-main.c
        drivers/staging/comedi/drivers/cb_das16_cs.c
        drivers/staging/cx25821/cx25821-alsa.c
        drivers/staging/dt3155/dt3155_drv.c
        drivers/staging/netwave/netwave_cs.c

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
