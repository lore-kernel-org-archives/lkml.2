Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283Ab0GTMkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:40:05 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38821 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756581Ab0GTMkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:40:04 -0400
Message-ID: <000d01cb2808$ac78d300$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <andrew.chih.howe.khor@intel.com>, <joel.clark@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>, <qi.wang@intel.com>,
        "LKML" <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>
References: <4C204B0D.2030201@dsn.okisemi.com> <201007152135.00280.arnd@arndb.de> <000601cb27e4$3768c170$66f8800a@maildom.okisemi.com> <201007201129.53110.arnd@arndb.de>
Subject: Re: [PATCH] I2C driver of Topcliff PCH
Date: Tue, 20 Jul 2010 21:40:00 +0900
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

> That is a highly unusual interface and I would definitely not recommend doing
> this. Please use an ioctl operation for anything that has both input and output
> data.
I will delete the special interface from our i2c driver.

Thanks, Ohtake
----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: <andrew.chih.howe.khor@intel.com>; <joel.clark@intel.com>; "Wang, Yong Y" <yong.y.wang@intel.com>;
<qi.wang@intel.com>; "LKML" <linux-kernel@vger.kernel.org>; <linux-i2c@vger.kernel.org>; "Ben Dooks (embedded
platforms)" <ben-linux@fluff.org>; "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Sent: Tuesday, July 20, 2010 6:29 PM
Subject: Re: [PATCH] I2C driver of Topcliff PCH


> On Tuesday 20 July 2010, Masayuki Ohtake wrote:
> > > > @@ -147,6 +148,11 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
> > > >  if (tmp == NULL)
> > > >  return -ENOMEM;
> > > >
> > > > + if (copy_from_user(tmp, buf, count)) {
> > > > + kfree(tmp);
> > > > + return -EFAULT;
> > > > + }
> > > > +
> > > >  pr_debug("i2c-dev: i2c-%d reading %zu bytes.\n",
> > > >  iminor(file->f_path.dentry->d_inode), count);
> > >
> > >
> > > A read function should not do copy_from_user, only copy_to_user.
> > > If you are worried about returning invalid data from kernel space,
> > > better use kzalloc instead of kmalloc to get the buffer.
> >
> > Our I2C HW has special mode.
> > To control the mode, our i2c driver has copy_from_user.
>
> That is a highly unusual interface and I would definitely not recommend doing
> this. Please use an ioctl operation for anything that has both input and output
> data.
>
> Arnd
>


