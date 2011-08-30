Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1H3HSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:18:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33377 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab1H3HR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:17:59 -0400
Date: Tue, 30 Aug 2011 09:17:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Peter Zijlstra <peterz@infradead.org>, Arnaud Lacombe <lacombar@gmail.com>,
        David Airlie <airlied@redhat.com>,
        Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
Message-ID: <20110830071755.GB15134@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaud Lacombe <lacombar@gmail.com>,
	David Airlie <airlied@redhat.com>,
	Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
	Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@gmail.com>, linux-kbuild@vger.kernel.org
References: <20110829141612.GB2025@gere.osrc.amd.com>
 <1790021880.1347470.1314632844694.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
 <20110829155501.GC2025@gere.osrc.amd.com>
 <CACqU3MVZek9TCcZEAbJXZqy9JZs3cbzNVJpwjOhS8OoKqH_YZQ@mail.gmail.com>
 <20110829171750.GD2025@gere.osrc.amd.com>
 <1314641813.2816.133.camel@twins>
 <20110829211439.GA4488@liondog.tnic>
 <20110830020828.GA14915@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110830020828.GA14915@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:08:28PM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 29 Aug 2011, Borislav Petkov wrote:
> > So, hypothetically speaking, hpa suggested then that we could pass
> > firmware blobs over the linked list setup_data thing in the real-mode
> > kernel header and parse_setup_data() can look at them and map them
> > somewhere later for the driver to find. This should be doable because
> > you're only gonna need a handful of blobs for CPU ucode, network and GPU
> > if the last is compiled in.
> > 
> > I wanted to take a serious look at that for the ucode loading, maybe I
> > should try to shuffle some time for it...
> 
> It would be very useful, yes.
> 
> Alternatively, you could extend the initrd format to have a firmware
> directory appended after the filesystem image.  ACPI is going to abuse
> the initrd in just that way to override ACPI tables very soon (patches
> have been already submitted to linux-acpi),

.. lemme guess: they didn't put the correct tables in the BIOS in the
first place and now it is too late for a BIOS fix and want to shuffle in
all those "fixes" through initrd ontop of ACPI. Oh boy, do I love all
the ACPI crap stories :).

> so if a more structured and extensible way to piggy-back early-init
> data in the initrd is needed, it would be good to bring that to the
> table NOW.

Yeah, that's not more than an idea right now, I haven't even started
playing with it. If it turns out to be more superior, it could be reused
for other things too but right now it's too early to tell.

-- 
Regards/Gruss,
    Boris.
