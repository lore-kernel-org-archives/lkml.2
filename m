Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab2KXHE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 02:04:56 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:52646 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab2KXHEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 02:04:55 -0500
Date: Sat, 24 Nov 2012 08:03:37 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: jaswinder.singh@linaro.org
Cc: ciminaghi@gnudd.com, viresh.linux@gmail.com, giancarlo.asnaghi@st.com,
        rajeev-dlh.kumar@st.com, linux@arm.linux.org.uk, nico@fluxnic.net,
        vinod.koul@intel.com, linus.walleij@linaro.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, wim@iguana.be,
        mingo@redhat.com, ben-linux@fluff.org, djbw@fb.com, tglx@linutronix.de,
        cjb@laptop.org, linux-arm-kernel@lists.infradead.org,
        davidb@codeaurora.org
Subject: Re: [PATCH 1/8 v3] DMA: PL330: use prefix in reg names to build
 under x86
Message-ID: <20121124070337.GA8030@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <CAJe_ZhcGmeTviV8v8eCMFZTWLnOb24_kVa1TkZF=9oyc6=vA4A@mail.gmail.com>
References: <CAJe_ZhcGmeTviV8v8eCMFZTWLnOb24_kVa1TkZF=9oyc6=vA4A@mail.gmail.com>
  <CAKohpokUHv96wutU1ZLxxnndR3wfTr3kjh3UKREtuiVV-V8+EA@mail.gmail.com>
  <1353718436-20194-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My patch:
>> This driver would not compile if ARM_AMBA is selected under x86,
>> because "CS" and "DS" are already defined there.  But AMBA
>> is used in the x86 world by a PCI-to-AMBA bridge, to be submitted.
>>
>> The patch just adds the "PL330_" prefix to all register and bit fields,
>> so it can be built by randomconfig after ARM_AMBA appears within x86.

Jassy Brar:
> Prefixing only CS and DS should be do the job.
> Why do we have to make every symbol noisy with PL330_ ?

For internal consistency. I attacked this problem in July. This is
what you wrote:

   I fully agree with your point and IIRC I always add some prefix to
   definitions in header files.
   Private defines in a .c file, without redundant prefixes, sounded like
   safe to me at the time, but perhaps I was wrong.

   (references: http://lkml.org/lkml/2012/7/1/56)

So I made the changes overall.  I dislike needless long patches, but
picking symbols to work around the conflict of the day while
introducing inconsistent naming doesn't look good to me.

The other option is making the driver depend on CONFIG_ARM, like other
patches in the series.  That would be a smaller patch: we have a dozen
AMBA peripherals under X86, and the PL330 was not thre.

But I got the impression that we don't want to single-out every driver
that doesn't compile: an overall more portable system is better.

I'm fine either way, but your "perhaps I was wrong" above made me choose
the overall-prefixing approach.

Thank you all for your patience in this (especially Davide for the
upstreaming effort)

/alessandro
