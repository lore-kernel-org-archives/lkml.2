Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab1EGTVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 15:21:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53218 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab1EGTVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 15:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tJ1nZ3Wpn7w6DXZXBEIQK5Fy3c62sfZwhtFJH9T2AkwSE+JCL3Kx7ZbVSu8InwWJyE
         Po+U/9uodaVkywdUXAvZOlTdMn/pp5whUcM1+oIvWcTDfRCMrH9NHxIvcIAdVE4V08X0
         NWf7YFoAgk3L6KNZvMuwNh0On//RUxKEYW/wc=
MIME-Version: 1.0
In-Reply-To: <1304794931.13983.44.camel@dev.znau.edu.ua>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<201105061605.31625.arnd@arndb.de>
	<BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	<BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	<1304790665.13983.10.camel@dev.znau.edu.ua>
	<BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com>
	<1304792795.13983.28.camel@dev.znau.edu.ua>
	<BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
	<1304794931.13983.44.camel@dev.znau.edu.ua>
Date: Sat, 7 May 2011 21:21:46 +0200
Message-ID: <BANLkTik9FWgzpNWuMXXRjOj-rDvPNY_nCA@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/7 George Kashperko <george@znau.edu.ua>:
>> >>
>> >> The purpose is ridiculously trivial. Print user-friendly names on
>> >> scanning. Why not do that?
>> > Output like
>> > Core 0: ChipCommon (id 0x800, rev 18, vendor 0x14e4)
>> > and
>> > Core 0: id 0x800, rev 18, vendor 0x14e4
>> > both give to 99% of linux systems' end-users exactly the same consistent
>> > information. Its more than enough for diagnostic purposes (I guess
>> > scanning code does outputs this for diagnostic purposes by those less
>> > than 1% of people who are aware wth is actually that ChipCommon is, not
>> > to be just user friendly?).
>>
>> Really, what's wrong with that? Does it kill anyone's pet we print
>> this? We also do:
>> pr_err("Scanning failed because of wrong CID\n");
>> return -1;
>> While we could drop pr_err. Why to do this? Advanced used can always
>> check what -1 means.
>>
>> I just like this. I find situations when it's useful, while I don't
>> see real negatives. I want to keep this. Can we leave this that way?
>> Unless someone finds some really bad effects of this?
> Nothing wrong except it makes kernel larger while gives _absolutely_ no
> benefit to end users. Regardless bus code prints core name or not it
> (core name) have absolutely no impact on driver matching.
>
> Imagine yourself an end-user who haven't got his 80211 core matched with
> driver and therefore he haven't got WiFi working.
> If bus driver code outputs
> Core X: id 0x812, rev. 8, vendor 0x4BF
> you (as end user) will look where is 0x4BF/0x812 driver supporting
> rev.8.
> But if bus driver code outputs
> Core X: MAC 802.11 (core id 0x812, rev. 8, vendor 0x4BF)
> you (as end user) empowered with MAC 802.11 name knowledge will still
> look where is 0x4BF/0x812 driver supporting rev.8.

I'll ask linux-wireless instead of linux-usb or linux-arm.

I didn't expect longer discussion so I got this trivial example of
pr_err. But it appears to be good example/question.

How do you see relation between bcma_device_name and:
int zd_ioread32v_locked(...) {
	if (r) {
		dev_dbg_f(zd_chip_dev(chip),
			  "error: zd_ioread16v_locked. Error number %d\n", r);
		return r;
	}
}

I believe according to your theory we should drop thi error message,
right? It eats memory to keep this string while error code can always
be checked in source.

-- 
Rafał
