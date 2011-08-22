Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1HVJZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:25:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57914 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab1HVJZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:25:13 -0400
Date: Mon, 22 Aug 2011 10:24:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/19] GPIO exodus and cleanup
Message-ID: <20110822092459.GL12028@n2100.arm.linux.org.uk>
References: <1312978564-18069-1-git-send-email-linus.walleij@stericsson.com> <20110817090123.GD1006@n2100.arm.linux.org.uk> <CACRpkdbJOrb5rhgG0Chamt-ApLQnV69MQ=bqBwKqO3KJPaFd0A@mail.gmail.com> <CACRpkdYw96QD0sGOhA=osKYbnD6=MTqiAF=m5++BjM-s1Mn--w@mail.gmail.com> <CACxGe6tEOnUzFjKMqNfp10b8SyuJDDFzg0eiPzhKNNCY55LECw@mail.gmail.com> <CACRpkdbPFuFHBuHzO2bP+z=za2kOFk4AZdgMVy=U6kcMmw9LSw@mail.gmail.com> <20110822082700.GK12028@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110822082700.GK12028@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 09:27:00AM +0100, Russell King - ARM Linux wrote:
> On Mon, Aug 22, 2011 at 09:53:48AM +0200, Linus Walleij wrote:
> > On Sun, Aug 21, 2011 at 9:09 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > > On Fri, Aug 19, 2011 at 5:45 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > >> Ping on this, on monday I'll pretend it's no big deal and pour them
> > >> into Russells patch tracker anyway, since he's managing more than
> > >> half of the kernels GPIO code in arch/arm/* anyway.
> > >
> > > If Russell is okay with it, then go ahead and merge it.  I'm being
> > > pretty liberal about GPIO driver moves.  I'm fine with them getting
> > > cleaned up after the drivers/gpio move.
> > 
> > Okay! Russell I've put them into your patch tracker as patches
> > 7032/1 thru 7050/1 so you can pick and choose. I've rebased on
> > top of what's in -next hoping that the stuff there affecting these
> > file will mainly be identical to what's on your "gpio" branch.
> > 
> > Tell me if I should rebase on something specific or if there are
> > any problems.
> 
> I've applied as many as I can, but 7042/1, 7046/1, 7047/1 and 7048/1
> failed:
> 
> Patching 7042/1...
> git apply --whitespace=fix -p1 --index --check > /tmp/pdb.26923 2>&1 exited with non-zero status: 256
> error: patch failed: drivers/gpio/gpio-ep93xx.c:24
> error: drivers/gpio/gpio-ep93xx.c: patch does not apply
> Patching 7046/1...
> git apply --whitespace=fix -p1 --index --check > /tmp/pdb.26923 2>&1 exited with non-zero status: 256
> error: patch failed: arch/arm/mach-mmp/gplugd.c:9
> error: arch/arm/mach-mmp/gplugd.c: patch does not apply
> error: drivers/gpio/gpio-pxa.c: does not exist in index
> Patching 7047/1...
> git apply --whitespace=fix -p1 --index --check > /tmp/pdb.26923 2>&1 exited with non-zero status: 256
> error: patch failed: drivers/gpio/Makefile:40
> error: drivers/gpio/Makefile: patch does not apply
> Patching 7048/1...
> git apply --whitespace=fix -p1 --index --check > /tmp/pdb.26923 2>&1 exited with non-zero status: 256
> error: drivers/gpio/gpio-pnx4008.c: does not exist in index
> 
> It looks like there are changes to these in other trees which conflict.

Looking through the gpio.h files, plat-nomadik's is virtually empty
except for a copyright, ifdef and include of linux/kernel.h - can it
be killed off entirely now?
