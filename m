Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab2KEBGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 20:06:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61410 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2KEBGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 20:06:01 -0500
MIME-Version: 1.0
In-Reply-To: <CA+T6QPkWLXx6-Bh-4VdsdoHypHNkJ4hTdkk-rqUEyGEswpW6fQ@mail.gmail.com>
References: <50924DA3.1060901@ti.com> <F49CA12D-4DAC-4293-AD4D-FC7EDCEA6993@antoniou-consulting.com>
 <20121101110418.GF410@arwen.pp.htv.fi> <3AF5A6FC-61D9-40CA-85B3-81C2C788CB76@antoniou-consulting.com>
 <20121101124025.GA12489@arwen.pp.htv.fi> <A16B0ABF-AB9D-4F48-88BD-96F123FFEF2F@antoniou-consulting.com>
 <20121101131609.GC12489@arwen.pp.htv.fi> <E911D0B7-0397-4ED0-828E-71F9531E84E0@antoniou-consulting.com>
 <20121101135148.382aec00@pyramind.ukuu.org.uk> <9F25E89E-9194-4725-8A8C-053DCBADA1DB@antoniou-consulting.com>
 <20121101220518.GE14982@arwen.pp.htv.fi> <CA+Bv8XbAvEXe=zDaA8W2+ROD2duYMRcJu4-bms31OH=V_ScKow@mail.gmail.com>
 <20121102112104.4657fb7b@pyramind.ukuu.org.uk> <CA+T6QPkWLXx6-Bh-4VdsdoHypHNkJ4hTdkk-rqUEyGEswpW6fQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 5 Nov 2012 01:05:39 +0000
X-Google-Sender-Auth: oTZJ0g0XrUM_qYiKId77_SGMy0A
Message-ID: <CACxGe6uKag_7kKvqKPHa_3W_F3=HLLR9SmyTo8vHRYN3VU+XnQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
To: Jason Kridner <jkridner@beagleboard.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Russ Dill <Russ.Dill@ti.com>,
        balbi@ti.com, Pantelis Antoniou <panto@antoniou-consulting.com>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 4:07 PM, Jason Kridner <jkridner@beagleboard.org> wrote:
>> Take a look at arch/x86/platform/mrst/mrst.c. It's a specific example of
>> a platform which parses tables and attaches devices to the right physical
>> bus in a manner they can be reliably probed even when the device has no
>> sane autodetect.
>
> I know I *am* the slow person in the room, but doesn't this approach
> require the code to be compiled into the kernel to support the devices
> ahead of time? While I think it might be reasonable to have hardware
> developers provide DT fragments in their EEPROMs, there's no way to
> get them to submit code patches in order to get their hardware to
> work. They need to ship hardware that works with pre-existing
> software, since there will be hundreds of boards created by people
> with little to no previous Linux experience (akin to Arduino). I seem
> to be missing how that approach would get us there.

If it is truly new hardware, then there really is no way around them
either a) submitting new kernel drivers or b) driving them from
userspace.

If it is devices with existing drivers populated onto new custom cape
boards, then the DT fragment approach should be sufficient for
populating them into the Linux driver model. (assuming of course those
drivers are already compiled into the kernel)

g.
