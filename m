Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1CYWiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:38:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63106 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab1CYWiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=ekzLdCjKx4X5ZbuoCQFXX/SMBxfrc8H+xbzFOAUIypjPzkVyD3XPwCoFbH+3Prk/EL
         T+HDO3iVeXbC9NwiFPX5B3VriqkTLIu74yZZtczBuIM42L4pcf2Kk1eAVB62PP4r6HeE
         /quNiyejPiXLtjxyqbvUj+uhvRC0lpb71Me5M=
MIME-Version: 1.0
In-Reply-To: <201103252335.14676.arnd@arndb.de>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <201103252112.22520.arnd@arndb.de> <20110325222346.GS3130@pulham.picochip.com>
 <201103252335.14676.arnd@arndb.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 18:38:00 -0400
X-Google-Sender-Auth: DZSL75zj2J_puKu50PSGDItugmE
Message-ID: <AANLkTinQ_M92zDZx_Jfe=rvPO0Gr4kHhXZUATvgVBywh@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 18:35, Arnd Bergmann wrote:
> One more thing that I just realized:
> I think it would be better not to allow arbitrary ioctl commands to
> be interpreted by the individual drivers. Instead, interpret them
> in the common code and pass the data to the drivers through separate
> otp_device_ops function pointers, one per ioctl command.
>
> This will reduce the amount of code needed in each driver when you
> have multiple ones implementing the same ioctls, and help to
> ensure that they all treat the arguments in the same way.

i think we should do what the rtc framework did ... there are common
ioctls which call specific function pointers in the driver, and any
unhandled ioctls get passed to the driver-specific ioctl function.
this should cover everyone's needs.
-mike
