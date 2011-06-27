Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1F0VXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 17:23:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55417 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab1F0VXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:23:05 -0400
From: "Grosen, Mark" <mgrosen@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Stephen Boyd <sboyd@codeaurora.org>
CC: davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC 0/8] Introducing a generic AMP/IPC framework
Thread-Topic: [RFC 0/8] Introducing a generic AMP/IPC framework
Thread-Index: AQHML+QkyBZcsabgrUapQCsRzbK3+pTNS1MAgAHkwICAAnvWQA==
Date: Mon, 27 Jun 2011 21:22:15 +0000
Message-ID: <FFF198FBBF957F4393BA834040FEFFA202EDA3@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
	<4E04F0B0.4030408@codeaurora.org>
 <BANLkTi=sFtwam29i4TZdi=RO7BoytTTdrw@mail.gmail.com>
In-Reply-To: <BANLkTi=sFtwam29i4TZdi=RO7BoytTTdrw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ohad Ben-Cohen
> Sent: Saturday, June 25, 2011 6:12 PM
> 
> Hi Stephen,
> 
> On Fri, Jun 24, 2011 at 11:16 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > Instead of devising a new firmware format, we decided
> > to just stick with elf and parse the headers in the kernel because we
> > needed them for authentication anyway. Is this reason enough to move to
> > an ELF format instead?
> 
> I think that consolidation of code is enough reason to make an effort.
> I know that our firmware format was chosen for simplicity, but I'm not
> sure if we have the tools yet to build standard ELF files for the
> remote processors (IIRC it's in the works though). I'll let Mark
> comment this one.

Yes, we are converting from "standard" ELF to the simple format. I've used the
GNU binutils to work with our ELF files. There were a few motivations:

1. Concern about complexity of parsing ELF files in kernel; however, the PIL
implementation looks pretty clean to me.

2. We added a special section (resource table) that is interpreted as part
of the loading process. The tool that generates our simple format just
recognizes a named section (".resource_table"), so perhaps that could be
done with the PIL ELF loader.

3. Smaller firmware file sizes. Our ELF files are large relative to the
payload, but this might be addressed by a better ELF "strip" utility.

> > Another difference is inter-processor dependencies. For example, on
> > msm8660 the modem can't boot until the dsp has been booted. I suppose we
> > could hide this detail in the platform specific get() implementation by
> > calling rproc_get() on the dependent processor (hopefully no locking
> > issues arise). I'd rather have it built into the core though as it isn't
> > really specific to the hardware.
> 
> No problems, I'm sure we can solve this one easily.
> 
> > If we can resolve these differences I think we can easily support remote
> > processor boot on MSM via remoteproc.
> 
> That'd be very cool, I sure do hope we can work together.

Yes, I hope we can merge our efforts on PIL and remoteproc since they seem
quite close in function and design.

Mark
