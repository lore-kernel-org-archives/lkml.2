Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0LGMzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:55:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65231 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0LGMzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:55:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
Date: Tue, 7 Dec 2010 13:55:08 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se> <201012071344.01173.arnd@arndb.de> <AANLkTi=Av1N2URqpgrAUCreFoJXb6ZtEkkgp_Jo4BgRw@mail.gmail.com>
In-Reply-To: <AANLkTi=Av1N2URqpgrAUCreFoJXb6ZtEkkgp_Jo4BgRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012071355.08714.arnd@arndb.de>
X-Provags-ID: V02:K0:cb5lRcIBTvijnJowgEKuldMVU6ldvMI8FPYrwhuXy5G
 W0SEnsNrglhg8tuLVjqdHh+ZjpxvevF8hxB87AUoOe5/7bdk7k
 mjbfaEVifdgKfCskZV0ga6pVYycUWfCyLgjCk7rFJdsvT7cAQ5
 zUs/Tt3c/nnGpVEfgoTPRFUZnPTYX1zm6UFuHV3P6WdshJA9DD
 17YGq8LAMryJsahhb6ayQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 December 2010, Kay Sievers wrote:
> >> Oh, how does that work? With the ioctl call, userspace has to supply
> >> the size it expects to be returned from the kernel. How does the
> >> kernel otherwise know how much it is allowed to copy to the user?
> >
> > The ioctl command number itself is calculated from the size of the
> > data that gets passed:
> >
> > #define EVIOCGDEVINFO          _IOR('E', 0x09, struct input_devinfo)
> >
> > If struct input_devinfo ever changes (which it can, but should not),
> > the command changes as well.
> 
> So unlike statet, it's not extensible, and this struct and this ioctl
> can never change?

Exactly. We have plenty of unused ioctl numbers free though.

	Arnd
