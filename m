Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0JJOJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 10:09:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35890 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab0JJOJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 10:09:12 -0400
Date: Sun, 10 Oct 2010 16:09:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Andi Kleen <andi@firstfloor.org>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION 2.6.36: radeon KMS console switch broken
Message-ID: <20101010140908.GA26728@basil.fritz.box>
References: <20101010123000.GD8256@basil.fritz.box>
 <20101010134429.GA1581@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101010134429.GA1581@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 03:44:29PM +0200, Markus Trippelsdorf wrote:
> On Sun, Oct 10, 2010 at 02:30:00PM +0200, Andi Kleen wrote:
> > 
> > Hi,
> > 
> > I see a radeon regression here with 2.6.36-rc7.
> > 
> > I updated a system from 2.6.35 to 2.6.36-rc7. Now I cannot 
> > switch to the text console from the X server anymore; the screen just 
> > keeps displaying the X desktop. Eventually when I switch back
> > to X things work again. 
> > 
> > The console switching worked in 2.6.35 
> > (I had occasional GPU hangs in .35, but console switch always worked)
> > I didn't change the Xserver userland.
> > 
> > The system has a ATI Technologies Inc RV710/730 running Dual Head.
> 
> You're using the radeonhd driver, which is not supported and outdated.
> Try to remove  /usr/lib64/xorg/modules/drivers/radeonhd_drv.so and start
> X again...

No you misread the Xorg.0.log: 

[    50.161] (II) Module radeonhd: vendor="AMD GPG"
...
[    51.636] (EE) FATAL: RadeonHD presently does not work with kernel modesetting (KMS).
...
[    50.167] (II) LoadModule: "radeon"
....
[    52.214] (II) UnloadModule: "radeonhd"
...

It's using radeon.

Besides if radeonhd stopped working that would be a regression too, but that's
not what we have here.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
