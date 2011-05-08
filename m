Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1EHKhT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 06:37:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38576 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1EHKhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 06:37:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oPz8/NU8fEasXva2Co6pICB8TsJbAB6Uf70luZvwfDC5HO7W/x7vCpxEDyupnnXert
         ck6jVbMTZADc8TBrzxF5fjltNASrruhzZLYHkiJ3wBZ3KbQkLleRJrXXzdpiIg+W2d8+
         oO2y280LUg9ov27ZZ4xcn/lVm1ll1llWMxs+I=
MIME-Version: 1.0
In-Reply-To: <20110508101609.GF27807@n2100.arm.linux.org.uk>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<201105061605.31625.arnd@arndb.de>
	<BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	<BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	<1304790665.13983.10.camel@dev.znau.edu.ua>
	<BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com>
	<1304792795.13983.28.camel@dev.znau.edu.ua>
	<BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
	<20110508101609.GF27807@n2100.arm.linux.org.uk>
Date: Sun, 8 May 2011 12:37:15 +0200
Message-ID: <BANLkTikMruTibp64GjE9qP9r80JiHgAFXw@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/8 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Sat, May 07, 2011 at 08:48:10PM +0200, Rafał Miłecki wrote:
>> Really, what's wrong with that? Does it kill anyone's pet we print
>> this? We also do:
>> pr_err("Scanning failed because of wrong CID\n");
>> return -1;
>> While we could drop pr_err. Why to do this? Advanced used can always
>> check what -1 means.
>
> And why return -1 when we have a system of error codes?  I _really_ wish
> people would stop returning -1 for "some random error occurred".

You commented on imagined code, but we actually do sth similar in code.

I did this because:
1) I had no idea what err code would be valid for invalid EPROM layout
(content). Nothing from include/asm-generic/errno-base.h sounds
reasonable.
2) I wanted to use different error codes for different EPROM layout
issues. Sometimes we don't get CIA block. Sometimes we don't get CIB
block. Sometimes there is problem with master port (not found in EPROM
when expected). They all would probably use the same errno.

Could you help me with this?

-- 
Rafał
