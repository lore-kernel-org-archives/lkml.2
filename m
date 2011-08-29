Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1H2VOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:14:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60256 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab1H2VOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:14:44 -0400
Date: Mon, 29 Aug 2011 23:14:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, David Airlie <airlied@redhat.com>,
        Michel =?utf-8?Q?D=C3=A4nzer?= <michel@daenzer.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
Message-ID: <20110829211439.GA4488@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1314641813.2816.133.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 08:16:53PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-29 at 20:09 +0200, Peter Zijlstra wrote:
> > > That would suck, suppose this radeon thing is the only console you've
> > > got (ppc64/sparc64 don't have text mode iirc) and userspace doesn't come
> > > up?
> > 
> > Same is true for NICs and netconsole of course. Not being able to stick
> > blobs into the kernel image would so suck. 
> 
> NICs and nfsroot, I suppose can you use an initrd over tftp as well, but
> really, what's the point of an in-kernel nfsroot if you need initrd
> crap.

Damn,

just when I thought that the lofty goal of Linux distancing itself from
firmware crap is within reach, you came up with all those real-life,
nagging examples.

So here's the whole deal IMHO:

* driver =m and request_firmware() works fine - you only need the blobs
in the right place.

* driver =y and request_firmware() should be fixed in all cases where
driver can wait.

Your use cases could probably be addressed by supplying firmware blobs
from the bootloader. We had this talk already concerning CPU microcode
updates and how the current method is to load CPU ucode when the module
gets loaded, which might be too late for some obscure (and not so
obscure) cases.

So, hypothetically speaking, hpa suggested then that we could pass
firmware blobs over the linked list setup_data thing in the real-mode
kernel header and parse_setup_data() can look at them and map them
somewhere later for the driver to find. This should be doable because
you're only gonna need a handful of blobs for CPU ucode, network and GPU
if the last is compiled in.

I wanted to take a serious look at that for the ucode loading, maybe I
should try to shuffle some time for it...

-- 
Regards/Gruss,
    Boris.
