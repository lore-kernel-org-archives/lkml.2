Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab0GTJ23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 05:28:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404Ab0GTJ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 05:28:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] I2C driver of Topcliff PCH
Date: Tue, 20 Jul 2010 11:27:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>,
        qi.wang@intel.com, "Wang, Yong Y" <yong.y.wang@intel.com>,
        joel.clark@intel.com, andrew.chih.howe.khor@intel.com
References: <4C204B0D.2030201@dsn.okisemi.com> <201007152135.00280.arnd@arndb.de> <000401cb27c7$ce732960$66f8800a@maildom.okisemi.com>
In-Reply-To: <000401cb27c7$ce732960$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007201127.57510.arnd@arndb.de>
X-Provags-ID: V02:K0:n06tiQwjZW1LNjfRNLViZCK5ASXeADXDmwDri0fRes1
 NWZ+eJghZxqdo8nfGoMqiPI9c47aKYr2Gvh2oZWPYgf5V5GpS6
 XdGxsqeDTBIYVvjwH/tiUtkVGSkC3XS/qsNIwVOmaOWepszCBY
 olXV/urnQINywq+Hww87DrcS0PnioxfEkQiPwxVFB4RWKShjgH
 NC8LDQ/XnQP6JPn2pMQQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 July 2010, Masayuki Ohtake wrote:
> > > +
> > > + dev_dbg(&pdev->dev,
> > > + "i2c_add_adapter returns %d for channel-%d\n", ret, i);
> > > + pch_init(&adap_info->pch_data[i]);
> > > + dev_dbg(&pdev->dev, "pch_init invoked successfully\n");
> > > + }
> > > +
> > > + ret = request_irq(pdev->irq, &pch_handler, IRQF_SHARED,
> > > +   MODULE_NAME, adap_info);
> >
> > Similarly, you would create a new channel data structure for each channel here
> > and register it separately, and then request the interrupt with that
> > data structure as the info.
> 
> With I2c multi-cahnnel IOH, IRQ number is in common.
> Thus, I think our PCH I2C driver can't be implemented like above.

If you pass IRQF_SHARED, you can register any number of handlers
for the same IRQ number using different dev pointers.

	Arnd
