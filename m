Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2K1QR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:17:27 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:55355 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2K1QRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:17:25 -0500
Date: Wed, 28 Nov 2012 17:15:39 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Alessandro Rubini <rubini@gnudd.com>, viresh.linux@gmail.com,
        giancarlo.asnaghi@st.com, rajeev-dlh.kumar@st.com,
        linux@arm.linux.org.uk, nico@fluxnic.net, vinod.koul@intel.com,
        linus.walleij@linaro.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, wim@iguana.be, mingo@redhat.com,
        ben-linux@fluff.org, djbw@fb.com, tglx@linutronix.de, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org, davidb@codeaurora.org
Subject: Re: [PATCH 1/8 v3] DMA: PL330: use prefix in reg names to build under x86
Message-ID: <20121128161539.GB16612@mail.gnudd.com>
References: <CAKohpokUHv96wutU1ZLxxnndR3wfTr3kjh3UKREtuiVV-V8+EA@mail.gmail.com> <1353718436-20194-1-git-send-email-ciminaghi@gnudd.com> <CAJe_ZhcGmeTviV8v8eCMFZTWLnOb24_kVa1TkZF=9oyc6=vA4A@mail.gmail.com> <20121124070337.GA8030@mail.gnudd.com> <CAJe_Zhck-vLQEHisE2ORbygmhA=7fcStuvOo2f4rvuCa1tAhEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAJe_Zhck-vLQEHisE2ORbygmhA=7fcStuvOo2f4rvuCa1tAhEg@mail.gmail.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 04:35:37PM +0530, Jassi Brar wrote:
> On 24 November 2012 12:33, Alessandro Rubini <rubini@gnudd.com> wrote:
> > My patch:
> >>> This driver would not compile if ARM_AMBA is selected under x86,
> >>> because "CS" and "DS" are already defined there.  But AMBA
> >>> is used in the x86 world by a PCI-to-AMBA bridge, to be submitted.
> >>>
> >>> The patch just adds the "PL330_" prefix to all register and bit fields,
> >>> so it can be built by randomconfig after ARM_AMBA appears within x86.
> >
> > Jassy Brar:
> >> Prefixing only CS and DS should be do the job.
> >> Why do we have to make every symbol noisy with PL330_ ?
> >
> > For internal consistency. I attacked this problem in July. This is
> > what you wrote:
> >
> >    I fully agree with your point and IIRC I always add some prefix to
> >    definitions in header files.
> >    Private defines in a .c file, without redundant prefixes, sounded like
> >    safe to me at the time, but perhaps I was wrong.
> >
> >    (references: http://lkml.org/lkml/2012/7/1/56)
> >
> > So I made the changes overall.  I dislike needless long patches, but
> > picking symbols to work around the conflict of the day while
> > introducing inconsistent naming doesn't look good to me.
> >
> Sorry if I gave the wrong impression. I didn't agree (and IIRC nobody
> suggested) we prefix _every_ symbol in the driver now. Just CS, DS, ES
> and maybe SA, DA, CC too for some consistency. IOW, only regs, not
> bit-fields.
>
Hi Jassi,

I've changed the patch to have registers only prefixed with PL300_ (no
prefix for bitfields).
Will send the new version in a few days (I'm still waiting for comments on
the other patches of the set).

Thanks and regards
Davide
