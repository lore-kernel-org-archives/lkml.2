Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab2EQGvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 02:51:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59399 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759850Ab2EQGvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 02:51:47 -0400
Date: Wed, 16 May 2012 23:51:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Bob Liu <lliubbo@gmail.com>
Subject: Re: [PATCH] input: rotary: Init wake according to platform pm_wakeup
 flag.
Message-ID: <20120517065141.GA24939@core.coreip.homeip.net>
References: <1337157383-13631-1-git-send-email-sonic.zhang@analog.com>
 <20120516183038.GA14471@core.coreip.homeip.net>
 <DB904C5425BA6F4E8424B3B51A1414D16F64F84E68@NWD2CMBX1.ad.analog.com>
 <20120517060803.GA24648@core.coreip.homeip.net>
 <DB904C5425BA6F4E8424B3B51A1414D16F64F84F29@NWD2CMBX1.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D16F64F84F29@NWD2CMBX1.ad.analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 02:32:37AM -0400, Zhang, Sonic wrote:
> Hi Dmitry,
> 
> >-----Original Message-----
> >From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> >Sent: Thursday, May 17, 2012 2:08 PM
> >To: Zhang, Sonic
> >Cc: linux-input@vger.kernel.org; LKML; uclinux-dist-devel@blackfin.uclinux.org;
> >Bob Liu
> >Subject: Re: [PATCH] input: rotary: Init wake according to platform pm_wakeup
> >flag.
> >
> >On Wed, May 16, 2012 at 10:58:00PM -0400, Zhang, Sonic wrote:
> >> Hi Dmitry,
> >>
> >>
> >> >-----Original Message-----
> >> >From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> >> >Sent: Thursday, May 17, 2012 2:31 AM
> >> >To: Zhang, Sonic
> >> >Cc: linux-input@vger.kernel.org; LKML; uclinux-dist-
> >devel@blackfin.uclinux.org
> >> >Subject: Re: [PATCH] input: rotary: Init wake according to platform pm_wakeup
> >> >flag.
> >> >
> >> >Hi Sonic,
> >> >
> >> >On Wed, May 16, 2012 at 04:36:23PM +0800, sonic.zhang@analog.com wrote:
> >> >> From: Sonic Zhang <sonic.zhang@analog.com>
> >> >>
> >> >> Rotary can't be used as a wakeup source in all Blackfin processors.
> >> >>
> >> >> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> >> >> ---
> >> >>  drivers/input/misc/bfin_rotary.c |    2 +-
> >> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> >>
> >> >> diff --git a/drivers/input/misc/bfin_rotary.c b/drivers/input/misc/bfin_rotary.c
> >> >> index 1c4146f..bb1971c 100644
> >> >> --- a/drivers/input/misc/bfin_rotary.c
> >> >> +++ b/drivers/input/misc/bfin_rotary.c
> >> >> @@ -182,7 +182,7 @@ static int __devinit bfin_rotary_probe(struct
> >> >platform_device *pdev)
> >> >>      bfin_write_CNT_CONFIG(bfin_read_CNT_CONFIG() | CNTE);
> >> >>
> >> >>      platform_set_drvdata(pdev, rotary);
> >> >> -    device_init_wakeup(&pdev->dev, 1);
> >> >> +    device_init_wakeup(&pdev->dev, pdata->pm_wakeup);
> >> >
> >> >I do not see pm_wakeup in bfin_rotary_platform_data.
> >>
> >> The patch against the bfin_rotary.h under blackfin architecture folder will be sent
> >out soon by Bob Liu.
> >
> >This split makes no sense - if I apply your patch to my tree it menas
> >that my tree will be broken on blackfin architecture until blackfin arch
> >gets pulled into mainline and I do next merge (around 3.5-rc3??). Please
> >combine both patches and get both pieces applied at the same time.
> >
> 
> The rotary Blackfin architecture patch is on top of the new bf60x
> machine patch sets. You may fail to apply it before the bf60x patches
> are merged.  Is it better to send you this patch later after you do
> next merge?

You may also add

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

to this patch and merge it through blackfin tree.

-- 
Dmitry
