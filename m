Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2JVLu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:50:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63289 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2JVLu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:50:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
Date: Mon, 22 Oct 2012 11:50:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Tony Prisk <linux@prisktech.co.nz>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz> <1350888712.3592.11.camel@gitbox> <20121022071118.GA30026@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121022071118.GA30026@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210221150.22004.arnd@arndb.de>
X-Provags-ID: V02:K0:onVqJ2MhgJf/ZETefwUDZBv4K1JrCnSKU6o4fCcL/No
 UR/tNg0xXe8ElPC9sd8AC4632Dvr4am6k4IabqeyXfGuL8FDzj
 N2Uqjz3vY/YApMtxX5o+FssWmh3YeOADQ0AZK+Le2bBR7DQmV4
 ojvpHAOFE9CIZPZvG/KWWuZvHSR8G9f6W36uG8TZW4QXO09X6l
 KMnKsuHKbd9msqCpPUaN8Yn+gv/dEjzQRVZIs26it6zBcn+3tQ
 lGcUqA1DRxglU6MU+Px5mxFucYfjuKDuMWKlUnpyLVlcRnQFIp
 pu+jn4Aci2GGVyDNIJpOjPqy5TuOXKcQJrxF5L9WgsL64d4DcI
 l4AlZBFCSxZcKmpudTYo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2012, Thierry Reding wrote:
> On Mon, Oct 22, 2012 at 07:51:52PM +1300, Tony Prisk wrote:
> > Replies to your comments inline:
> > 
> > On Mon, 2012-10-22 at 08:34 +0200, Thierry Reding wrote:
> > ...
> > > > -static int __devinit pwm_probe(struct platform_device *pdev)
> > > > +static const struct of_device_id vt8500_pwm_dt_ids[] = {
> > > > + { .compatible = "via,vt8500-pwm", },
> > > > + { /* Sentinel */ }
> > > > +};
> > > > +
> > > > +static int __devinit vt8500_pwm_probe(struct platform_device *pdev)
> > > 
> > > Since you're changing this line anyway, maybe you should drop __devinit
> > > (and __devexit for the .remove() callback). HOTPLUG is always enabled
> > > nowadays and will go away eventually, in which case these will need to
> > > be removed anyway.
> > 
> > Will do. I must say the inconstancy among comments is rather
> > frustrating. In another patch I sent out a few days ago (completely
> > unrelated to this), I told to add __devexit to a remove() function :\
> 
> This is a rather recent development, so maybe not everyone knows about
> it yet. You can look at the following commit for the details:
> 
>         45f035ab9b8f45aaf1eb2213218b7e9c14af3fc2
> 
> It's been in linux-next for about 6 weeks and has also gone into
> 3.7-rc1.

As long as we get build warnings for leaving out the __devinit/__devexit
annotations, I would generally recommend putting them in. If we do a
patch to remove all of them, a couple extra instances will not cause
any more troubles than we already have.

	Arnd
