Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab1COOBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:01:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55285 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab1COOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:01:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Mikhailov <karma@galois.botik.ru>
Subject: Re: lseek() on debugfs entries in 2.6.37
Date: Tue, 15 Mar 2011 15:01:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <874o74ilxl.wl%karma@galois.botik.ru>
In-Reply-To: <874o74ilxl.wl%karma@galois.botik.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151501.42105.arnd@arndb.de>
X-Provags-ID: V02:K0:s3/iMRjoahync6wp2I6Dtj31iX3xGtzZXkwGI/3JR1J
 xcWpYQ0f2BDLzstN48jON97io+CzROKPRcC5mo0tsGtkyLHPZE
 O81yYCzLByZ0GR+bEfoKISXgmE44RAeyYp2YARtzPsiKNVr+s3
 nglOz2Jh+ySQohvwDqLFQKZsXXR7tW44T+eVUuNDv6oJMHAsg7
 /t5si+y7CaJeLhH9MlYgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011, Alexey Mikhailov wrote:
> I use simple debugfs entries for user-space <-> kernel-space
> interaction. Basically I read unsigned integers from debugfs
> files like this:
> 
>    ...
>    char buf[64];
>    lseek(timesync_fd, 0, SEEK_SET);
>    read(timesync_fd, buf, sizeof(buf));
>    ...
> 
> It works perfectly with 2.6.32 kernel. But with 2.6.37 kernel,
> lseek() fails with errno=29(Illegal seek). So second read()
> call just fails or returns garbage. Can someone please shed
> some light on it?

This is probably a result of the changes I made as part of the
BKL removal. Which file specifically are you talking about?

In older kernels, having no .llseek function meant that you
implicitly get default_llseek. New kernels now require 
that the driver explicitly chooses one llseek variant.

I did a patch to automatically convert all drivers, but
this patch may have missed some that got moved around
while I was patching them.

	Arnd
