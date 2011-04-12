Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab1DLPZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:25:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56623 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab1DLPZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:25:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JRqFa5xA8fyE6YWCBR+3HiWSYXJXjhmHRRsFE2sQk+AQBxyNxqLkHhm8NImTRzj2Mq
         fA34E6+evwiOonqkUzn/KbBQC3TY+leVPsYD2RibAPwpGgzam2S8CBWKHWvCXQ2lWqqy
         +XcCS+5gU5J4TlxrV3p2meUDboDylvHO8NStw=
MIME-Version: 1.0
In-Reply-To: <20110412151453.GA20978@kroah.com>
References: <20110411210631.GA28559@kroah.com>
	<BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
	<20110411212513.GA17809@kroah.com>
	<BANLkTingqXAWTeOhcL6ER0UJfEdQF5Bo2A@mail.gmail.com>
	<20110411215619.GA27943@kroah.com>
	<BANLkTimjThXn347+=m98NsBXY84guJjNqA@mail.gmail.com>
	<20110411223632.GB31833@kroah.com>
	<BANLkTinpKKRCrBik6-9C5WqcSDGuEt5yCw@mail.gmail.com>
	<20110411233506.GA13240@kroah.com>
	<BANLkTi=cG3U8yXaQ6PusmNaWcr+AWv3e_w@mail.gmail.com>
	<20110412151453.GA20978@kroah.com>
Date: Tue, 12 Apr 2011 17:25:39 +0200
Message-ID: <BANLkTi=6tDsBF9jULDXLJ05zaHrD-+EC2g@mail.gmail.com>
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/12 Greg KH <greg@kroah.com>:
> On Tue, Apr 12, 2011 at 07:41:18AM +0200, Rafał Miłecki wrote:
>> > You can't do that, no static struct devices please.  Make these dynamic
>> > and everything will be fine.  The -mm tree used to have a huge warning
>> > if you ever tried to register a statically allocated struct, but that
>> > didn't really work out, but would have saved you a lot of time here,
>> > sorry.
>> >
>> > So dynamically allocate the structures and you will be fine.
>>
>> Well, I saw that along kernel, I had no idea there is anything wrong
>> about this. It seems more ppl do not know about this:
>> struct radeon_ib      ibs[RADEON_IB_POOL_SIZE];
>> struct radeon_pm_clock_info clock_info[8];
>> struct radeon_pm_profile profiles[PM_PROFILE_MAX];
>> struct radeon_surface_reg surface_regs[RADEON_GEM_MAX_SURFACES];
>
> Are you sure these are all containing a 'struct device'?

I didn't catch from you mail that you mean "struct device" only. I
though it apply to all structs.


>> checkpatch does no catch this, so maybe just some manual? Could you
>> point me to it?
>
> It's a structure that has dynamic lifetime rules, you can't statically
> allocate it safely.  It's that simple.

Ah, and this is a great explanation, for all the time I tough the
problem is memory issue. Now it makes sense, thanks.

-- 
Rafał
