Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0I3KiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 06:38:06 -0400
Received: from cmx.wol.de ([193.158.62.4]:59231 "EHLO cmx.wol.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0I3KiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 06:38:04 -0400
Subject: Re: [PATCH] Fix capi devicenames
From: "Marc - A. Dahlhaus" <mad@wol.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, isdn@linux-pingi.de
In-Reply-To: <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
References: <4CA391B3.1030806@wol.de>
	 <20100930103010.1a6a7785@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 30 Sep 2010 12:37:57 +0200
Message-Id: <1285843077.748.32.camel@marc>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 30.09.2010, 10:30 +0100 schrieb Alan Cox:
> On Wed, 29 Sep 2010 21:21:23 +0200
> "Marc - A. Dahlhaus" <mad@wol.de> wrote:
> 
> > capi device names should get changed to what userspace expects.
> 
> If userspace isn't following the spec (which has been the spec for many
> years) then thats not our problem.

Thanks Alan,

please read further, i think i didn't wrote the whole story in the patch
declarations.

> > Without this change recent udev versions can't produce working device
> > nodes as the capi control device node name "capi" collides with the
> > "capi" directory under which userspace expects to get the application
> > device nodes. This also fixes the Documentation.
> 
> The documentation isn't broken, the documentation *is* the reference.

The Documentation doesn't even represent what is in the code right now.
kernelcapi.ko creates /dev/capi as the capi control device
and /dev/capi[0-9]+ for the applications. Documentation states the
Devices are /dev/capi20 and /dev/capi20.[0-9]+ for applications.

> NAK. Fix udev.

I don't think udev is the right place to fix this.

Udev creates symlinks and is no longer able to overwrite the name
attribute.

CCing Kay Sievers for that.

> We have a spec for a reason, if some distro didn't follow it then that's
> up to them but they can sort out their own udev.

The problem is that eg. the capi module for pppd expects the application
nodes in a capifs conform path. capifs was in charge to create
the /dev/capi/[0-9]+ nodes but was deprecated and replaced by udev.

Old udev versions contained a isdn-40.rules file to create the capifs
nodes.

There was a discussion here about where to fix the false naming of
devices. And as far as i know it was decided that the right place is to
change them inside of the kernel and not via udev. Because of this udev
removed the possibility to change devicenodes to new names without
keeping the kernels suggested devicenode name. I hope i got this right.

So IMO the documentation is wrong. And also the kernelcapi module is
wrong about that node it creates.

The ISDN4Linux userspace expects the devicenodes in the way the patch
renames them for years:

http://www.isdn4linux.de/cgi-bin/viewcvs.cgi/isdn4k-utils/capiinit/capiinit.c?revision=1.17&view=markup

I just want that it works with the latest upstream sources out of the
box and this isn't the case right now.
CCing Karsten Keil for this.

> Alan

thanks,

Marc

