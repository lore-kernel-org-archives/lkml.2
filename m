Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab0GTJaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 05:30:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491Ab0GTJaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 05:30:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Subject: Re: [PATCH] I2C driver of Topcliff PCH
Date: Tue, 20 Jul 2010 11:29:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        "Wang, Yong Y" <yong.y.wang@intel.com>, qi.wang@intel.com,
        "LKML" <linux-kernel@vger.kernel.org>, linux-i2c@vger.kernel.org,
        "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Jean Delvare \(PC drivers, core\)" <khali@linux-fr.org>
References: <4C204B0D.2030201@dsn.okisemi.com> <201007152135.00280.arnd@arndb.de> <000601cb27e4$3768c170$66f8800a@maildom.okisemi.com>
In-Reply-To: <000601cb27e4$3768c170$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007201129.53110.arnd@arndb.de>
X-Provags-ID: V02:K0:fkLLwGQCugJGcKcV52tsYuUyPmuO/OJ/UcK7n+sHokw
 mYtDpcrITqkP8NPtvyo7XyJOX0SQp5xcJt7jD6d2/u7t6Zj4Sr
 AcLm4ArHq/PTlX5r7Y0U/xTumN62BGFN+s/xBKQbpVHXkNtBAX
 GRwwBfMJ2FDsp/28bBdH6HoMGftw+Z7YiF/yf5kLXNczRfN5N9
 bvItOQ1AeX3UpwAFpD4Ug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 July 2010, Masayuki Ohtake wrote:
> > > @@ -147,6 +148,11 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
> > >  if (tmp == NULL)
> > >  return -ENOMEM;
> > >
> > > + if (copy_from_user(tmp, buf, count)) {
> > > + kfree(tmp);
> > > + return -EFAULT;
> > > + }
> > > +
> > >  pr_debug("i2c-dev: i2c-%d reading %zu bytes.\n",
> > >  iminor(file->f_path.dentry->d_inode), count);
> >
> >
> > A read function should not do copy_from_user, only copy_to_user.
> > If you are worried about returning invalid data from kernel space,
> > better use kzalloc instead of kmalloc to get the buffer.
> 
> Our I2C HW has special mode.
> To control the mode, our i2c driver has copy_from_user.

That is a highly unusual interface and I would definitely not recommend doing
this. Please use an ioctl operation for anything that has both input and output
data.

	Arnd
