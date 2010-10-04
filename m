Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0JDNt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:49:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0JDNt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:49:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Belisko Marek <marek.belisko@gmail.com>
Subject: Re: [PATCH 3/6] staging/ft1000-usb: fix build warnings
Date: Mon, 4 Oct 2010 15:49:20 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <1285835052-11880-1-git-send-email-arnd@arndb.de> <1285835052-11880-4-git-send-email-arnd@arndb.de> <AANLkTi=EFX0SiTOQ-7N=OapO=xkoBR_dFhVMrdDLBs_+@mail.gmail.com>
In-Reply-To: <AANLkTi=EFX0SiTOQ-7N=OapO=xkoBR_dFhVMrdDLBs_+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201010041549.21088.arnd@arndb.de>
X-Provags-ID: V02:K0:GWb1V1KhJBEQgELhxd/JuRcScFD8St0GW+wILDszlFF
 WeREvaGZ6jxBd0f3sldT+8QAC8U5Yd/TLA7dLlwuAcqKoALwKp
 E+GEbmTftJUc5iinHgbbOWW4PDTWgpkASlA1Ykw0gVRNWCZ6uG
 BpAyHt5wN4C/1CKPpwE9Go3qCiGRzbWPKY8/RfpfA0Ahm8TWNP
 lQ5N/PV1ZnVUb03Q8fSDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 October 2010, Belisko Marek wrote:
> >                     if (qtype) {
> >                     }
> > @@ -756,6 +762,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
> >                                         if (tempword & FT1000_DB_DPRAM_TX) {
> >                                             DEBUG("FT1000:ft1000_ChIoctl:Doorbell not available\n");
> >                                             result = -ENOTTY;
> > +                                               kfree(dpram_data);
> is shift of kfree() needed or just a typo?
> >                                             break;
> >                                         }
> >                                     }

Indentation in this driver is largely broken (should be using tabs only, but
uses tabs and spaces). I didn't want to add to this, but I guess it doesn't
matter much either way.

You should probably split larger functions into multiple smaller ones where
sensible so you can do a proper reindentation of the whole driver.

> Anyway there is also compilation warning:
> In function ‘copy_from_user’,
>     inlined from ‘ft1000_ChIoctl’ at
> drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c:709:36:
> /home/open-nandra/kernels/linux-next/arch/x86/include/asm/uaccess_32.h:212:26:
> warning: call to ‘copy_from_user_overflow’ declared with attribute
> warning: copy_from_user() buffer size is not provably correct
> 

This warning is compiler dependent, so it didn't show up on my system.
Just make an extra patch for it.

	Arnd
