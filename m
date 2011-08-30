Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1H3Ihm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 04:37:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52914 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1H3Ihj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 04:37:39 -0400
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Peter Zijlstra <peterz@infradead.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@alien8.de>, Arnaud Lacombe <lacombar@gmail.com>,
        David Airlie <airlied@redhat.com>,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kbuild@vger.kernel.org
Date: Tue, 30 Aug 2011 10:37:22 +0200
In-Reply-To: <20110830020828.GA14915@khazad-dum.debian.net>
References: <20110829141612.GB2025@gere.osrc.amd.com>
	 <1790021880.1347470.1314632844694.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
	 <20110829155501.GC2025@gere.osrc.amd.com>
	 <CACqU3MVZek9TCcZEAbJXZqy9JZs3cbzNVJpwjOhS8OoKqH_YZQ@mail.gmail.com>
	 <20110829171750.GD2025@gere.osrc.amd.com> <1314641813.2816.133.camel@twins>
	 <20110829211439.GA4488@liondog.tnic>
	 <20110830020828.GA14915@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314693442.2054.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 23:08 -0300, Henrique de Moraes Holschuh wrote:
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
> have been already submitted to linux-acpi), so if a more structured and
> extensible way to piggy-back early-init data in the initrd is needed, it
> would be good to bring that to the table NOW.

Uhm,.. does that mean that soon we can't boot kernels without initrd?
That too is a massive regression in my eyes.
