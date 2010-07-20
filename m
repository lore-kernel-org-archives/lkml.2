Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273Ab0GTMia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:38:30 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:5025 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758287Ab0GTMi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:38:27 -0400
Message-ID: <000801cb2808$72aef870$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        <linux-i2c@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        <joel.clark@intel.com>, <andrew.chih.howe.khor@intel.com>
References: <4C204B0D.2030201@dsn.okisemi.com> <201007152135.00280.arnd@arndb.de> <000401cb27c7$ce732960$66f8800a@maildom.okisemi.com> <201007201127.57510.arnd@arndb.de>
Subject: Re: [PATCH] I2C driver of Topcliff PCH
Date: Tue, 20 Jul 2010 21:38:22 +0900
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

> If you pass IRQF_SHARED, you can register any number of handlers
> for the same IRQ number using different dev pointers.
I will modify like above.

Thanks, Ohtake.
----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>; "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>;
<linux-i2c@vger.kernel.org>; "LKML" <linux-kernel@vger.kernel.org>; <qi.wang@intel.com>; "Wang, Yong Y"
<yong.y.wang@intel.com>; <joel.clark@intel.com>; <andrew.chih.howe.khor@intel.com>
Sent: Tuesday, July 20, 2010 6:27 PM
Subject: Re: [PATCH] I2C driver of Topcliff PCH


> On Tuesday 20 July 2010, Masayuki Ohtake wrote:
> > > > +
> > > > + dev_dbg(&pdev->dev,
> > > > + "i2c_add_adapter returns %d for channel-%d\n", ret, i);
> > > > + pch_init(&adap_info->pch_data[i]);
> > > > + dev_dbg(&pdev->dev, "pch_init invoked successfully\n");
> > > > + }
> > > > +
> > > > + ret = request_irq(pdev->irq, &pch_handler, IRQF_SHARED,
> > > > +   MODULE_NAME, adap_info);
> > >
> > > Similarly, you would create a new channel data structure for each channel here
> > > and register it separately, and then request the interrupt with that
> > > data structure as the info.
> >
> > With I2c multi-cahnnel IOH, IRQ number is in common.
> > Thus, I think our PCH I2C driver can't be implemented like above.
>
> If you pass IRQF_SHARED, you can register any number of handlers
> for the same IRQ number using different dev pointers.
>
> Arnd
>


