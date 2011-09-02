Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1IBPth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:49:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53233 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab1IBPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:49:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] mfd: Combine MFD_SUPPORT and MFD_CORE
Date: Fri, 2 Sep 2011 17:49:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Luciano Coelho <coelho@ti.com>, Randy Dunlap <rdunlap@xenotime.net>,
        matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <201108311849.37273.arnd@arndb.de> <20110902143713.307bbebe@endymion.delvare>
In-Reply-To: <20110902143713.307bbebe@endymion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109021749.10638.arnd@arndb.de>
X-Provags-ID: V02:K0:mFXB3CAD9TWMBjga2M2XFmz0BSsGNOJe1dW+YUEPood
 ydUKV7qAmttlMmKbL+i1TNyGfuXCo35maSUedHSJl8fOruvm45
 F3BjldgCx50WwuTiRQE2R4ahALDFULrVVNInvxxGAWXo/6QJZW
 pIoythKdS3RZg7V6NxEnVrCqb+pK2KHw4gQ++oGrfD8pXlYyWn
 W7fIfgvfVG8CwEFaFP+i2/tB8psuTPwczcVvDkyGqHU12Cyxhj
 5Izn36bfJ7utaY/8MUQsxQx+8AaIE8LJ3VIjP93/4gBAFj/9vq
 Py1rke56K/PoYZB7GuK0FBFimLJvc7UE2s5VPdCx3wbxteKEn8
 0PQfN5FqlTz1X7NxxqD4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 September 2011, Jean Delvare wrote:
> > Doing this is a good idea, but incidentally I have just spent some time
> > with the same problem and ended up with a solution that I like better,
> > which is removing CONFIG_MFD_SUPPORT altogether.
> > 
> > The point is that there is no use enabling MFD_CORE if you don't also
> > enable any of the specific drivers.
> 
> Same holds for pretty much every subsystem, right?

I think not: MFD is a bit different from other subsystems in that it does
not have a user space interface by itself. It's also different from bus
drivers in that it is not specific to some particular class of hardware,
since it only abstracts devices that do multiple things independent of
how they do them.

It is similar to MISC_DEVICES (drivers/misc) in some regards, and I
would also like to turn that one back from menuconfig into menu for
the same reasons.

> > MFD_SUPPORT was added as a 'menuconfig'
> > before we had Kconfig warn about broken dependencies, so everything was
> > fine. Since Kconfig now issues the warnings, I think it would be better
> > to just turn the MFD menu into a plain 'menu' and remove all the
> > 'depends on MFD_SUPPORT' and 'select MFD_SUPPORT' lines from the other
> > Kconfig files.
> 
> This would make it impossible to turn off all MFD drivers at once. I
> think this is considered a feature, at least I find it very convenient
> to be able to "kill" a subsystem completely. And in the past few years
> many subsystems were turned from menu to menuconfig for this reason.
> But maybe MFD is a special case here.

I agree that it's convenient for a lot of subsystems to be able to
turn them off entirely, but in case of MFD and MISC, I cannot see a clear
use case for that.

> Anyway, if you want your patch to be applied, you'll have to send it
> for review first, as at this point all we have is Luciano's proposal.

Ok. I had actually meant to send this mail out before the patches, but
apparently it got stuck in my mail client.

	Arnd
