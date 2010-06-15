Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0FOMMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:12:24 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:43276 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633Ab0FOMMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:12:23 -0400
Message-ID: <000a01cb0c84$01e0d7c0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <4C0CE88C.9050708@dsn.okisemi.com> <201006141450.53572.arnd@arndb.de> <000401cb0c53$91a9e300$66f8800a@maildom.okisemi.com> <201006151242.28097.arnd@arndb.de>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Tue, 15 Jun 2010 21:12:17 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thank you for your comments.
I can understand your intention.
I misunderstood about Kconfig behavior.

Thanks,
Ohtake.

----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>; "LKML" <linux-kernel@vger.kernel.org>; "Andrew"
<andrew.chih.howe.khor@intel.com>; "Intel OTC" <joel.clark@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y"
<yong.y.wang@intel.com>
Sent: Tuesday, June 15, 2010 7:42 PM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> On Tuesday 15 June 2010, Masayuki Ohtake wrote:
> > >This should not be necessary. Just use CONFIG_PCH_CAN_PCLK_50MHZ directly
> > >in the code instead of the extra PCH_CAN_PCLK_50MHZ macro.
> >
> > I have a question. I show the above reason.
> > In case CAN is integrated as MODULE, macro name is CONFIG_PCH_CAN_PCLK_50MHZ_MODULE.
> > On the other hand, integrated as built-in, CONFIG_PCH_CAN_PCLK_50MHZ.
> > To prevent PHUB source code from integrated as MODULE or BUILT-IN,
> > we re-define macro name in Makefile.
> >
> > If use CONFIG_PCH_CAN_PCLK_50MHZ directly in the source code,
> > in case buit-in, behavior is not correct.
> > But in case module, behavior is not correct.
>
> I don't understand the problem, because you have the definition
>
> config PCH_CAN_PCLK_50MHZ
>        bool "CAN PCLK 50MHz"
>        depends on PCH_PHUB
>
> which is 'bool', not 'tristate', so it can never be a module.
> If you are referring to a dependency on the CAN code that is
> not part of this patch, you can express this as
>
> config PCH_CAN_PCLK_50MHZ
>        bool "CAN PCLK 50MHz"
>        depends on PCH_PHUB || CAN != "n"
>
> This will leave CONFIG_PCH_CAN_PCLK_50MHZ as bool and let it only
> get enabled if CONFIG_CAN is either "y" or "m".
> Does that answer your question?
>
> Arnd
>


