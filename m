Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0JAIgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 04:36:39 -0400
Received: from cmx.wol.de ([193.158.62.4]:41458 "EHLO cmx.wol.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab0JAIgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 04:36:38 -0400
Subject: Re: [PATCH] Fix capi devicenames
From: "Marc - A. Dahlhaus" <mad@wol.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        isdn@linux-pingi.de
In-Reply-To: <AANLkTimRa9VsOgSkcdrg=41pskEbMhNL4D9SXeV3dztG@mail.gmail.com>
References: <4CA391B3.1030806@wol.de>
	 <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
	 <1285843077.748.32.camel@marc>
	 <AANLkTi=d+5uDVK9RHguSmwFhKLVUPXvzo=G3s=NKKDW3@mail.gmail.com>
	 <20100930122928.19e5ee84@lxorguk.ukuu.org.uk>
	 <1285851024.748.97.camel@marc>
	 <AANLkTimRa9VsOgSkcdrg=41pskEbMhNL4D9SXeV3dztG@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 01 Oct 2010 10:36:32 +0200
Message-Id: <1285922192.13411.53.camel@marc>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 30.09.2010, 21:20 +0200 schrieb Kay Sievers:
--8<--
> 
> devices.txt is just bogus in this case and states stuff which was
> never used in the real world. But you don't need to touch it. Just add
> the naming hints (char *(*devnode)) to the capi class and nothing will
> change, the device names in /sys and everywhere else will stay as they
> are today, just devtmpfs and udev will create the right device nodes
> out of the kernel supplied additional information. We did this for the
> rest of the kernel the same way.

Hello Kay,

for the capi tty, if not mistaken, it looks like i need to add a
dev->devnode = 'capi/';
line but i have no clue what it needs to change the capi_class.
Looks like a larger rework of the code in capi.c to me.

It would collide in the kernel if i fix the typo for the control device
but don't change the tty device name by the same time.
(20th capi application tty would become capi20 under sysfs)

So i took the approach to ignore the devices.txt in the v2 patch and
just fix the control device node to conform to the spec and also fix the
tty node names to the ones of capifs that superseded the manualy created
tty device nodes mentioned in devices.txt

Hope this is more appropriate than my first patch.

Is there a documentation that could guide me in how to fix it in the way
you suggested, if the v2 patch also gets naked?

thanks,

Marc

