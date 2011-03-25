Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1CYWxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:53:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61162 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1CYWxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:53:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Fri, 25 Mar 2011 23:53:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <201103252335.14676.arnd@arndb.de> <AANLkTinQ_M92zDZx_Jfe=rvPO0Gr4kHhXZUATvgVBywh@mail.gmail.com>
In-Reply-To: <AANLkTinQ_M92zDZx_Jfe=rvPO0Gr4kHhXZUATvgVBywh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103252353.42901.arnd@arndb.de>
X-Provags-ID: V02:K0:HpNhdw9mGoG4gWROpa0MPc5MtXsm4J9QkhRidFbjARZ
 WUJleLTtoiGnoxnbgS58RZxNIlioalK+GTSRmD8E8Zb9oeiAWZ
 K+S+brhB8/GwdBim/Ebu10w6+ylvNOFep6uoYipr2xRFgwW97W
 3SNK1YEOQPp0q4dJtP5rz8syF+2IXXZnUbEk0R+/dvnCPZA0UK
 KVUMyfk+zIF0rxznL9Gbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 March 2011 23:38:00 Mike Frysinger wrote:
> On Fri, Mar 25, 2011 at 18:35, Arnd Bergmann wrote:
> > One more thing that I just realized:
> > I think it would be better not to allow arbitrary ioctl commands to
> > be interpreted by the individual drivers. Instead, interpret them
> > in the common code and pass the data to the drivers through separate
> > otp_device_ops function pointers, one per ioctl command.
> >
> > This will reduce the amount of code needed in each driver when you
> > have multiple ones implementing the same ioctls, and help to
> > ensure that they all treat the arguments in the same way.
> 
> i think we should do what the rtc framework did ... there are common
> ioctls which call specific function pointers in the driver, and any
> unhandled ioctls get passed to the driver-specific ioctl function.
> this should cover everyone's needs.

It depends on how obscure the ioctls get, but I think the first
attempt should always be to standardize them across the subsystem.
A lot of things are wrong with the whole concept, but when they
are needed, you should at least try to shield individual drivers
from them.

Many subsystems end up needing both common and driver specific
ioctls as they grow, I just wouldn't do that to start out with.
There's always hope that the latest subsystem will be better than
the others ;-).

	Arnd
