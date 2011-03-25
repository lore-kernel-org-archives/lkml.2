Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab1CYXCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:02:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1CYXCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:02:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Sat, 26 Mar 2011 00:02:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <AANLkTinQ_M92zDZx_Jfe=rvPO0Gr4kHhXZUATvgVBywh@mail.gmail.com> <20110325225220.GV3130@pulham.picochip.com>
In-Reply-To: <20110325225220.GV3130@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103260002.19291.arnd@arndb.de>
X-Provags-ID: V02:K0:vGst3C4DLb1TyZKcb7u/vBsX8Rsk82CmaG4jX87j+0H
 wL6q6yDXla3JR2NfI+RZjTf6gLs18yLm/cOd8rEgZkKs5DP+v3
 wEZ0mIbMtncP6GPj+JUmemzfCUEKnmt1e+/TWkcTGpgXoaJWmc
 sCD8eAQzHjhUUe8/aBIxHUA8ibyUG3WOhNPtD/VS3JUZAg1Ep3
 tY/ry74kLItf4GOr3ChNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 March 2011 23:52:20 Jamie Iles wrote:
> That's what I intended but I guess it isn't that clear from the code.  
> Perhaps instead of:
> 
>         mutex_lock();
>         region->ops->ioctl();
>         mutex_unlock();
> 
> if I change it to:
> 
>         mutex_lock();
>         switch (cmd) {
>         default:
>                 region->ops->ioctl();
>         }
>         mutex_unlock();
> 
> then that's a bit clearer.  If there's stuff common across different OTP 
> implementations then we can add it to the region ops and decode it here 
> and if not fall back to the specific implementation.

This will make it a lot harder to support compat_ioctl as well.
Just drop the ->ioctl callback into the driver and make one
callback per command. Any command that could be reused on
another driver will then be defined in the common header file
already and just work on new drivers.

If you are tempted to add commands that cannot possibly work
on other hardware, that is usually a good indication that this
command should not be added, or should be generalized in some way.

	Arnd
