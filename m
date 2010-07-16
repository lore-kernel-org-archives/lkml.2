Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628Ab0GPFk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 01:40:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40097 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935580Ab0GPFkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 01:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iECvD4Qaiua7mtlPDNWrYeSyIoXvc/es+Z6LZgneMxH2oTpQJzucleTiaWtCHQU/bH
         jvRo9NMJUwKLbviBfdj3uOlZzpO1Rjtm2fZ6wVNYQ5ZzcL2jIi3ELz1EZkzqu/OMhBAt
         kwNl2uDwJymd3rc+1fbCAGb1f3je5lUD1LfSA=
MIME-Version: 1.0
In-Reply-To: <20100715163526.GJ29322@n2100.arm.linux.org.uk>
References: <AANLkTimyBHliUa62qmfja_ke6YTTysiVAtJcZfi8l2gG@mail.gmail.com>
	<AANLkTil8GE1OguyAfp3XgfJvEmH98yNrlvGAx684a-qL@mail.gmail.com>
	<20100715163526.GJ29322@n2100.arm.linux.org.uk>
Date: Fri, 16 Jul 2010 13:40:24 +0800
Message-ID: <AANLkTilasw5P7-mwHol0-GpYixwqZ8tcdI3tX6elVhE4@mail.gmail.com>
Subject: Re: tq 2440
From: Conke Hu <conke.hu@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: CoffBeta <coffbeta@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
        inux kernel <linux-kernel@vger.kernel.org>,
        ext-jani.1.nikula@nokia.com,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 12:35 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jul 15, 2010 at 11:16:30PM +0800, Conke Hu wrote:
>> ever notice to the following kernel log?
>> "Device 's3c2440-nand' does not have a release() function, it is
>> broken and must."
>> release() function should be implemented  in the platform_device.
>
> That's not telling you to provide a release function.  The warning is
> telling you that a device is being unregistered which doesn't have a
> release function.
>
> Consider this point - maybe it doesn't have a release function because
> it's not supposed to be unregistered?
>
>> > ------------[ cut here ]------------
>> > WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x30/0x44()
>> > sysfs: duplicate filename 'dm9000.0' can not be created
>
> This is the cause of the problem.  You're registering two dm9000.0
> devices.  That's illegal, and it then causes all these:
>
>> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
>> > Device 's3c24xx_led.3' does not have a release() function, it is broken and mus.
>> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
>> > Device 's3c24xx_led.2' does not have a release() function, it is broken and mus.
>> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
>> > Device 's3c24xx_led.1' does not have a release() function, it is broken and mus.
>> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
>> > Device 's3c24xx_led.0' does not have a release() function, it is broken and mus.
>> > WARNING: at drivers/base/core.c:122 device_release+0x6c/0x78()
>> > Device 's3c2440-nand' does not have a release() function, it is broken and must.
> ...
>
> Fix the first problem (which is the real one) and you won't have these
> other problems (which aren't actually a problem.)
>

Right:)
