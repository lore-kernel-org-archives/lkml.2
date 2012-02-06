Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2BFUDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:03:53 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60598 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2BFUDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:03:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120204021457.GA25386@khazad-dum.debian.net>
References: <4F27120A.4040106@suse.cz> <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
 <4F27C54F.1010107@suse.cz> <CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com>
 <20120204021457.GA25386@khazad-dum.debian.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 6 Feb 2012 21:03:31 +0100
Message-ID: <CAPXgP12yZ74679JNwRB-pDfnjOBaxMzL2=krSDK31jM1mjXfuA@mail.gmail.com>
Subject: Re: network regression: cannot rename netdev twice
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jiri Slaby <jslaby@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 03:14, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Tue, 31 Jan 2012, Kay Sievers wrote:
>> Please make sure nothing tries to swap netif names in userspace. We
>> have given up that approach, because it is far too fragile to
>> temporary rename devices to be able to swap the names, and race
>> against the loading of new kernel network drivers at the same time.
>
> That's a damn fair reason, but the loss of that functionality could cause
> trouble.  In fact, at first glance, to me it looks like this has a large
> potential for unleashing untold pain and suffering in the sysadmin ranks
> unless early userspace can emulate it somehow.
>
> Is it possible to configure the kernel to use something other than "eth#" as
> its initial namespace for netif names?  Or is there some other way to get
> eth1 to be what you need eth1 to be during userland boot?

I don't think there is a sane way to do that. Someone could add a
kernel command line parameter to switch ethX in the kernel to
something else, and create custom udev rules which match on device
properties and apply configured names which are ethX again. But for
all that, there will be no generally available support in common base
system tools, and we absolutely do not recommend anybody doing that.

Udev will not provide any help for that any more, not for automatic
device name reservation from a hotplug path, not for device name swaps
in the kernel namespace. It will only be allowed to rename devices to
a namespace that does not clash with the kernel's one.

People should use biosdevname's pci-slot names, or the on-board labels
names like DELL does for configuration-less stable names, or use
manually configured names 'internal', 'external' ,'dmz', 'vpn' and so
on.

I think we should stop pretending we can solve problems, resulting
from simple enumeration depending on device-discovery order. These
numbers can never be stable, can never reliably work in the reality we
are working with.

It's time to leave these false promises behind us and move on and that
means, no stable ethX names anymore.

Kay
