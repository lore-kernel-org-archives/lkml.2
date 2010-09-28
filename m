Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0I1HVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:21:09 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:37204 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab0I1HVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:21:08 -0400
Message-ID: <000e01cb5edd$b750f2b0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Mike Frysinger" <vapier@gentoo.org>,
        "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Alek Du" <alek.du@intel.com>, <richard.rojfors@mocean-labs.com>,
        <meego-dev@meego.com>,
        "ML linux-kernel" <linux-kernel@vger.kernel.org>,
        "Qi" <qi.wang@intel.com>, <andrew.chih.howe.khor@intel.com>,
        <gregkh@suse.de>, "Yong Y" <yong.y.wang@intel.com>,
        "Tomoya MORINAGA" <morinaga526@dsn.okisemi.com>,
        <joel.clark@intel.com>, <margie.foster@intel.com>,
        <kok.howg.ewe@intel.com>
References: <4C80D3C8.9020204@dsn.okisemi.com> <20100903134827.GA7614@rakim.wolfsonmicro.main> <000301cb5ebc$35ad8d20$66f8800a@maildom.okisemi.com> <201009272338.23762.vapier@gentoo.org> <002801cb5ec9$b7936a00$66f8800a@maildom.okisemi.com> <AANLkTikUJMfo8m8o1rQdf264g2P39uHLRp80vGPW0Jni@mail.gmail.com> <003001cb5ecd$97577930$66f8800a@maildom.okisemi.com> <AANLkTi=PvwA81YiZszUu2B=rDoBhduJwdWv2CrYWWu+f@mail.gmail.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35
Date: Tue, 28 Sep 2010 16:21:03 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike and Mark,

> [root@localhost gpio]# ls
> export  gpiochip244  unexport
> [root@localhost gpio]# echo 1 > export
> bash: echo: write error: Invalid argument
> [root@localhost gpio]#

I could confirm GPIO node creation with success using the following command.
echo 244 > export

It seems "gpiochip244" means base GPIO number is 244 NOT 0.

Thanks, Ohtake(OKISemi)
----- Original Message ----- 
From: "Mike Frysinger" <vapier@gentoo.org>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>; "Andrew Morton" <akpm@linux-foundation.org>; "Samuel Ortiz"
<sameo@linux.intel.com>; "Randy Dunlap" <randy.dunlap@oracle.com>; "Alek Du" <alek.du@intel.com>;
<richard.rojfors@mocean-labs.com>; <meego-dev@meego.com>; "ML linux-kernel" <linux-kernel@vger.kernel.org>; "Qi"
<qi.wang@intel.com>; <andrew.chih.howe.khor@intel.com>; <gregkh@suse.de>; "Yong Y" <yong.y.wang@intel.com>; "Tomoya
MORINAGA" <morinaga526@dsn.okisemi.com>; <joel.clark@intel.com>; <margie.foster@intel.com>; <kok.howg.ewe@intel.com>
Sent: Tuesday, September 28, 2010 2:32 PM
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_GPIO driver to 2.6.35


> On Tue, Sep 28, 2010 at 01:25, Masayuki Ohtake wrote:
> >> find out what range of GPIO numbers your driver is using and use those
> >> instead of "1"
> >
> > I have attached a part of our source file.
> >
> > Since I set "ngpio=12",
> > I guess 0-11 can be used, thus, "echo 1 > export" should be success too.
> > Is this true ?
>
> there are often multiple gpio sources in a system.  whichever one is
> registered first (usually the arch/cpu specific one) tends to start at
> 0.
>
> i'm merely providing generic gpio information.  i know nothing of your
> specific arch/cpu/board setup.  you'll have to do some
> digging/debugging on your side.
> -mike
>


