Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2KGJkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:40:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53620 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab2KGJkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:40:20 -0500
MIME-Version: 1.0
In-Reply-To: <20121107082820.GP30936@casco.aei.mpg.de>
References: <20121107082820.GP30936@casco.aei.mpg.de>
Date: Wed, 7 Nov 2012 17:40:19 +0800
Message-ID: <CAD9gYJ+2D6-Lu4L_CNEjsypd6WxhUzmkC1gY5STQSPp41p6J5Q@mail.gmail.com>
Subject: Re: Need assistance fixing a tg3 driver side-effect on IPMI
From: =?GB2312?B?zfW98MbW?= <jinpuwang@gmail.com>
To: Steffen Grunewald <Steffen.Grunewald@aei.mpg.de>
Cc: LKML <linux-kernel@vger.kernel.org>, htejun@gmail.com, tj@kernel.org,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/7 Steffen Grunewald <Steffen.Grunewald@aei.mpg.de>:
> Hi everyone,
>
> I've been running into a problem while installing Debian Wheezy on a bunch
> of 6-year old machines which have been running Squeeze happily for years.
>
> They are SuperMicro-based (H8SSL opteron board), with two BCM95704A6 (Tigon3)
> interfaces, and a BMC/IPMI card (SuperMicro 1U) which shares eth0.
>
> With a 2.6.32 kernel (and the 3.102 version of the tg3 driver) everything is fine.
>
> With Debian's 3.2 (and tg3 3.121) I lose access to the IPMI LAN (or LANplus)
> interface as soon as the tg3 module has been loaded. Even shutting down doesn't
> give the interface back - I've got to pull the power plug.
>
> Trying to git bisect the corresponding changes to the tg3 driver, I'm running
> against a wall at the point where the source code has been moved to another
> subtree back in 2011 (still a long time past Squeeze). I appear to be unable
> to go back beyond that.
>
> Can you advise how to find out when IPMI access got lost, and how to re-enable
> it? Any suggestion is appreciated.
> I suppose it wouldn't be as easy as "get the old source from 2.6.32, and plug
> it into drivers/net/ethernet/broadcom, then rebuild the kernel" -?
>
> Please keep me on CC, thanks.
>
> Regards,
>  Steffen
> --
Ferenc met samilar problem :

"Michael Chan" <mchan@broadcom.com> writes:

> On Tue, 2012-10-02 at 18:49 +0200, Ferenc Wagner wrote:
>
>> Going into the opposite direction: I found that Linux 3.6 does not
>> permanently break the SoL console on upping eth0!  I'll try to find
>> the commit which (sort of) fixed it.
>
> These are the likely fixes:
>
> commit cf9ecf4b631f649a964fa611f1a5e8874f2a76db
> Author: Matt Carlson <mcarlson@broadcom.com>
> Date: Mon Nov 28 09:41:03 2011 +0000
>
> tg3: Fix TSO CAP for 5704 devs w / ASF enabled

You are exactly right: cf9ecf4b fixed the premanent SoL breakage
introduced by dabc5c67.  Looks like ASF utilizes similar technology to
that of the HS20 BMC.  Thanks for the tip, it greatly reduced our CPU
wear. :)  It's a pity ethtool -k did not give a hint.  Do you think it's
possible to work around in 3.2 by eg. fiddling some ethtool setting?

the fix already go into Precise update to 3.2.31 stable release

So update your kernel should fix your problem.

Jack
