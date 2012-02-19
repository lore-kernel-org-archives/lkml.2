Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2BSOXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 09:23:08 -0500
Received: from 7.mo5.mail-out.ovh.net ([178.32.124.100]:55590 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753911Ab2BSOXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 09:23:07 -0500
X-Greylist: delayed 20999 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Feb 2012 09:23:06 EST
Date: Sun, 19 Feb 2012 08:07:38 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@avr32linux.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 16/18] Atmel: move console default platform_device to
 serial driver
Message-ID: <20120219070738.GA491@game.jcrosoft.org>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
 <81ce940f5ac09c5d50bfa712ab10a785f28df4ea.1329500622.git.nicolas.ferre@atmel.com>
 <20120218091749.GA22669@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120218091749.GA22669@samfundet.no>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11632234888104618918
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:17 Sat 18 Feb     , Hans-Christian Egtvedt wrote:
> Around Fri 17 Feb 2012 18:50:08 +0100 or thereabout, Nicolas Ferre wrote:
> > From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > 
> > This variable spread on every SoC that is using the atmel_serial.c
> > driver can be included directly into the latter.
> > 
> > This will allow to compile multiple soc in the same kernel.
> 
> Sounds like a good idea, but...
> 
> <snipp AT91 changes>
> 
> > diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> > index 402a7bb..889c544 100644
> > --- a/arch/avr32/mach-at32ap/at32ap700x.c
> > +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> > @@ -1055,8 +1055,6 @@ struct platform_device *__init at32_add_device_usart(unsigned int id)
> >  	return at32_usarts[id];
> >  }
> >  
> > -struct platform_device *atmel_default_console_device;
> > -
> >  void __init at32_setup_serial_console(unsigned int usart_id)
> >  {
> >  	atmel_default_console_device = at32_usarts[usart_id];
> 
> I doubt this assignment will work if you remove the struct above. I did not
> look at how AT91 does this, will it be similar affected?
none the still exist in the kernel, its just moved

Best Regards,
J.
