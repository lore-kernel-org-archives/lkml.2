Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2HNKAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:00:25 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36152 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2HNKAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:00:24 -0400
MIME-Version: 1.0
In-Reply-To: <20120810093458.GA13192@sig21.net>
References: <20120801152240.GA16388@sig21.net>
	<CACRpkdZryc95WpSXddCrLvZGDsv4x-ndX9XcVzoxaDCT53AFLw@mail.gmail.com>
	<501F296B.4070004@wwwdotorg.org>
	<CACRpkdZ8AO5SrjJvJxvpauEadQOKMNaW_Pxxzhjk5hWnVB1b+g@mail.gmail.com>
	<20120806095805.GA16607@sig21.net>
	<501FA608.1030805@firmworks.com>
	<20120810093458.GA13192@sig21.net>
Date: Tue, 14 Aug 2012 12:00:23 +0200
Message-ID: <CACRpkdbQVHFWej=CPv0QOjH7OUr8Jj7wVjG=eRqkM=cbih1vAQ@mail.gmail.com>
Subject: Re: DT GPIO numbering?
From: Linus Walleij <linus.walleij@linaro.org>
To: Johannes Stezenbach <js@sig21.net>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Mitch Bradley <wmb@firmworks.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 11:34 AM, Johannes Stezenbach <js@sig21.net> wrote:

> Actually I think the kernel internal GPIO numbers shouldn't be in the
> sysfs API, instead userspace should use the names.

This is true, but we cannot remove these numbers because they
are now in Documentation/ABI/testing/sysfs-gpio

And while the "testing" ABI is, well for testing, it would probably
break a lot of stuff it we removed it.

But we can sure add names. However these would still sit under
/sys/class/gpio/gpioN/name

Or do you suggest we simply duplicate all GPIOs which have
names under /sys/class/gpio/named/<name>
or something like that?

I know Grant may have opinions on this...

>  Probably it's
> best to not use /sys/class/gpio/export but instead let the board
> init code export the GPIOs available to userspace with proper names.

This sounds true.

Yours,
Linus Walleij
