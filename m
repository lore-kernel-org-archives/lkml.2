Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab1CZKyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 06:54:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1CZKyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 06:54:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Sat, 26 Mar 2011 11:54:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <20110326002159.GY3130@pulham.picochip.com> <AANLkTinYd+4vtSBmBGHJwbCgFiZttSTtgQaQ0txwoUxt@mail.gmail.com>
In-Reply-To: <AANLkTinYd+4vtSBmBGHJwbCgFiZttSTtgQaQ0txwoUxt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103261154.18619.arnd@arndb.de>
X-Provags-ID: V02:K0:s0/Tn8N1sKtLQZhSolc/AyEcX4A2PzpW3MwKLCvQ9Nw
 THuWW0RM8XyGRXLYncbK4ZvmpPXa/SrsnvVvQzKs0EiTuBoHNe
 C8AvsOkMI2gNXjP64J0MHxxCmvryYIGhQS3RzBEVWgi2Ep8jKd
 PbptXUVjmxg5OXIqnBXQ9Ur7GiLeADiyXFA4DD88bG7hT6t3ui
 MM/giKx2vSsacMLJga2tA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 March 2011 03:16:48 Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 20:21, Jamie Iles wrote:
> > For the actual ioctl() we should assume byte addressing rather than
> > words though and do the conversion in the driver so we can cope with
> > devices that don't have 64-bit words and do the locking on a looping
> > word-by-word basis.
> >
> >        struct otp_lock_req {
> >                __u32   start_addr;
> >                __u32   byte_count;
> >        };

Looks good to me.

> i would add an ABI field here too so if in the future we want to add
> stuff, we can do so without adding new ioctls.  like "u16 version; u16
> flags;".  then in the ioctl, if version isnt 0, we return ENOTSUP.  in
> the future, we can add flags or bump the version.

No, versioned APIs are just a pain to maintain, it's easier to add
new ioctl commands when necessary.
Note that the kernel would always have to support all versions of
the API anyway.

	Arnd
