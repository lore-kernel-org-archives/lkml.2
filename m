Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab1CYWfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:35:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60026 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab1CYWfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:35:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Fri, 25 Mar 2011 23:35:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, vapier@gentoo.org
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <201103252112.22520.arnd@arndb.de> <20110325222346.GS3130@pulham.picochip.com>
In-Reply-To: <20110325222346.GS3130@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103252335.14676.arnd@arndb.de>
X-Provags-ID: V02:K0:7tO3Pd24hN0dmW+Ug8c6mzHStNFuKqXO592tqdkSDIv
 iItD0wWuv9g0Cbju6iTE3XrCrqAgAMEeaaCQzSMtlhByw1/J69
 J2c6jlCMMbupn2htu1/weNW3vEwg9O9aLbEeb0Dfajcor+tW/c
 J2dKN6ma0igtwRKJKEbyLFp344CO3jywp22DboC6uO3/dX9AgO
 46u0Js25pirKg/HWKg49w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 March 2011 23:23:46 Jamie Iles wrote:
> Thanks for taking the time to look at this.  I think I've addressed all 
> of your comments in the v3 series apart from defining OTP (which really 
> does need to be done so I'll make sure I do that in v4) and the sysfs 
> bus/class stuff.

Wow, that was quick!

One more thing that I just realized:
I think it would be better not to allow arbitrary ioctl commands to
be interpreted by the individual drivers. Instead, interpret them
in the common code and pass the data to the drivers through separate
otp_device_ops function pointers, one per ioctl command.

This will reduce the amount of code needed in each driver when you
have multiple ones implementing the same ioctls, and help to
ensure that they all treat the arguments in the same way.

Also, you should have a compat_ioctl file operation. As long as
your data structures are compatible between 32 and 64 bit, it
can point to the same function as the .unlocked_ioctl one.

	Arnd
