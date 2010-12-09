Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab0LIRrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:47:01 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47219 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab0LIRq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:46:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fCrNJ0iSIVQ3wh1WWwvwahxRH3KxY0a01tyqzrsRCdZUn8cHQfm7P5hk4wW/Bk+45U
         2F+qUkI0dqzemJbdpDKxa7lCwxEaOQYCIQcX6sFU4ZdwpuC2BntrZ+hxXJbm3QmmdiNM
         C1cRFvJpiQxS0izQlSFuhKj5sRrBYIvrscAzs=
MIME-Version: 1.0
In-Reply-To: <20101209173525.GA29879@void.printf.net>
References: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com>
	<20101208115510.GD10998@console-pimps.org>
	<AANLkTi=KqOa-MRQiptCtZGvoafRCgULfE3QFs=hmGpdi@mail.gmail.com>
	<AANLkTi=PpTi1_JO9Q=ph7w9Jim8iXMf9LbCfmEkWuo-h@mail.gmail.com>
	<20101209064751.GA21128@void.printf.net>
	<AANLkTimMgrawcndvUTYYjq9BGFqs-sbRsZkwVQ0Uvhvb@mail.gmail.com>
	<20101209160157.GA28586@void.printf.net>
	<20101209173525.GA29879@void.printf.net>
Date: Thu, 9 Dec 2010 17:46:20 +0000
Message-ID: <AANLkTi=BXxfNcnhNb6Bd_N3gVpDUMWBCQtZ0d=m9p_sa@mail.gmail.com>
Subject: Re: [PATCH] dw_mmc: Add Synopsys DesignWare mmc host driver.
From: Will Newton <will.newton@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 5:35 PM, Chris Ball <cjb@laptop.org> wrote:
> Hi Andrew,
>
> On Thu, Dec 09, 2010 at 04:01:57PM +0000, Chris Ball wrote:
>> > > Is there something we could depend on that would stop this driver being
>> > > presented to everyone, without being far too specific?  At the moment
>> > > we'd be making x86 desktop users say whether they have this IP, which
>> > > isn't good.  Are the architectures that use this IP already upstream?
>> > > Are they all ARM architectures, for instance?
>> >
>> > I don't know of any architectures upstream that use this IP block. There is an
>> > SoC from NXP that uses this it but it is not upstream:
>> >
>> > http://ics.nxp.com/support/software/lpc313x.bsp.linux/
>> >
>> > The architecture we tested and debugged this driver on is not upstream either
>> > unfortunately. :-/
>>
>> Okay.  I think "depends on ARM" is appropriate for now, and we could
>> expand that later if the block appears in a MIPS SoC or something.
>> Does that work for you?
>
> Oh, hey, rmk says that he seems to recall that akpm says that if the
> driver builds on x86 (it does), we should just allow it to be built
> there too so that it gets build coverage.  Andrew, does this still
> represent your stance?
>
> I've heard the distro maintainers complain about having to investigate
> Kconfig entries for drivers that their users would never possibly use,
> though, and this certainly falls into that case.  Is there something
> better we can do here, to correctly hide this driver from non-ARM users
> but also make it clear that it can be built if somebody wants to do a
> mass driver build?

The driver does build on x86{_64} and it has been useful for me to do
that in the past to test cosmetic changes. It might also be good to
have it building on x86 to get more compile testing, as I suspect a
lot more people doing randconfig builds are doing it on x86 rather
than arm.

But I'm fine with it either way.
