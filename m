Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0KOLx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:53:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57984 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab0KOLx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:53:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: sedat.dilek@gmail.com
Subject: Re: [2.6.37-rc1-git11] none-BKL-config: stradis.c: error: implicit declaration of function 
 =?utf-8?q?=E2=80=98lock=5Fkernel=E2=80=99/=E2=80=98unlock=5Fker?=
 =?utf-8?q?nel=E2=80=99?=
Date: Mon, 15 Nov 2010 12:54:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
References: <AANLkTimgynsWk2pKvxkq7NdX75YguizyOWnVWPq7eXtL@mail.gmail.com>
In-Reply-To: <AANLkTimgynsWk2pKvxkq7NdX75YguizyOWnVWPq7eXtL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201011151254.10277.arnd@arndb.de>
X-Provags-ID: V02:K0:qs+px0amq7W8ZtOY7IX/UPVPbCpWADpYcg9cdvKp+DQ
 pfzrcHa+7KLQUtK8F6w5QKWt+xSEaGTK6HF5gINN/riV2Y74kN
 0rjpqun4m90Zl90ryBwD68aR0kncCz7Cx6dlt5aWTTQXeXGk5U
 gTd2zmvJovXb23MDKApkKt2zTh+CttDPNxOQQRJFmADbvfUxRF
 eygwBViNWbcp3SuHV1suA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 November 2010, Sedat Dilek wrote:
> with 2.6.37-rc1-git11 my none-BKL-config breaks (-git9 and -git9457b24
> were OK) in stradis staging-crap.
> Think the breakage aroses from [1].
> 
> $ cd ~/src/linux-2.6/linux-2.6.37-rc1/debian/build/source_i386_none
> 
> $ grep "error:" ../../../../build_linux-2.6_git11.sd.1.log
> /home/sd/src/linux-2.6/linux-2.6.37-rc1/debian/build/source_i386_none/drivers/staging/stradis/stradis.c:1891:
> error: implicit declaration of function ‘lock_kernel’
> /home/sd/src/linux-2.6/linux-2.6.37-rc1/debian/build/source_i386_none/drivers/staging/stradis/stradis.c:1897:
> error: implicit declaration of function ‘unlock_kernel’

The driver is on its way out. I'll do a patch to just mark it "depends
on BKL" to make sure it doesn't get built when BKL is disabled.

It would be relatively easy to fix the right way, if you are interested.

	Arnd
