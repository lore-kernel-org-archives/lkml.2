Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1BVPVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:21:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1BVPVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:21:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCHv2 09/11] unicore32 core architecture: timer and time handling
Date: Tue, 22 Feb 2011 16:21:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <02f301cbcb48$bebea4c0$3c3bee40$@mprc.pku.edu.cn> <201102171831.16713.arnd@arndb.de> <018c01cbd29b$759a4740$60ced5c0$@mprc.pku.edu.cn>
In-Reply-To: <018c01cbd29b$759a4740$60ced5c0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102221621.07655.arnd@arndb.de>
X-Provags-ID: V02:K0:pQKrvdzmuNMNpri/iZ8Cjm1mPacuN2hc36kHaAeSg1g
 E8+sPgvrdhGo3w01STGkY9f9XLPjIy4OZadkuTlHhimNuq7hLa
 eJcPUs4o/NtqnDNRmPwPNrOkaBKLG260zRKQKzHTWMlgfMdgOu
 MSJzQLf0XSWLXuMrQpxnpPAbmojGSFzjYAFrgA8CPu0UwCKt1q
 pVqj6/QYJkYhtxXfIcoPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 February 2011, Guan Xuetao wrote:
> > > +#if defined(CONFIG_PUV3_DB0913)                \
> > > +       || defined(CONFIG_PUV3_NB0916)  \
> > > +       || defined(CONFIG_PUV3_SMW0919)
> > > +
> > > +#define  CLOCK_TICK_RATE         (14318000)
> > > +
> > > +#endif
> > 
> > I believe that we don't use CLOCK_TICK_RATE in the kernel any more,
> > so there is no reason to define it.
> CLOCK_TICK_RATE is an important value for the kernel.
> And perhaps I misunderstanding your meaning...

We just discussed the same thing for a new ARM platform. You are
right that CLOCK_TICK_RATE is currently still being used, but
we are trying to get rid of it.

Most importantly, it should not be configuration specific any more.
If you use CLOCK_TICK_RATE in unicore32 specific code, it would
be best to rename that variable and device it in a board specific
file.

The definition in timex.h can basically contain any value that is
a multiple of CONFIG_HZ. Don't worry about this one, we will fix
it for good for the entire kernel.

	Arnd
