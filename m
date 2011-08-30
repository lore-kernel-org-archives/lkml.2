Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1H3Ozb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:55:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33337 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092Ab1H3Oz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:55:29 -0400
X-Sasl-enc: uZvki0A2CFYcAi2PmuGpeYb+6ZBAxyAuvrBzx8dPmKyU 1314716128
Date: Tue, 30 Aug 2011 11:55:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Arnaud Lacombe <lacombar@gmail.com>,
        David Airlie <airlied@redhat.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
Message-ID: <20110830145525.GB23963@khazad-dum.debian.net>
References: <20110829141612.GB2025@gere.osrc.amd.com>
 <1790021880.1347470.1314632844694.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
 <20110829155501.GC2025@gere.osrc.amd.com>
 <CACqU3MVZek9TCcZEAbJXZqy9JZs3cbzNVJpwjOhS8OoKqH_YZQ@mail.gmail.com>
 <20110829171750.GD2025@gere.osrc.amd.com>
 <1314641813.2816.133.camel@twins>
 <20110829211439.GA4488@liondog.tnic>
 <20110830020828.GA14915@khazad-dum.debian.net>
 <1314693442.2054.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314693442.2054.2.camel@twins>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011, Peter Zijlstra wrote:
> On Mon, 2011-08-29 at 23:08 -0300, Henrique de Moraes Holschuh wrote:
> > On Mon, 29 Aug 2011, Borislav Petkov wrote:
> > > So, hypothetically speaking, hpa suggested then that we could pass
> > > firmware blobs over the linked list setup_data thing in the real-mode
> > > kernel header and parse_setup_data() can look at them and map them
> > > somewhere later for the driver to find. This should be doable because
> > > you're only gonna need a handful of blobs for CPU ucode, network and GPU
> > > if the last is compiled in.
> > > 
> > > I wanted to take a serious look at that for the ucode loading, maybe I
> > > should try to shuffle some time for it...
> > 
> > It would be very useful, yes.
> > 
> > Alternatively, you could extend the initrd format to have a firmware
> > directory appended after the filesystem image.  ACPI is going to abuse
> > the initrd in just that way to override ACPI tables very soon (patches
> > have been already submitted to linux-acpi), so if a more structured and
> > extensible way to piggy-back early-init data in the initrd is needed, it
> > would be good to bring that to the table NOW.
> 
> Uhm,.. does that mean that soon we can't boot kernels without initrd?
> That too is a massive regression in my eyes.

Well, if work starts soon enough on a bootloader extension to avoid messing
with the initrd, we could refuse to set that initrd-based ACPI table
override as ABI on the grounds that it is a debug thing, and later move it
to the properly designed firmware bootloader extension.

Maybe the grub multiboot protocol[1] is worth looking at, assuming that
thing is salvagable and would actually work for both 32bit and 64bit BIOS
and UEFI bootstrapping?

[1]http://www.gnu.org/software/grub/manual/multiboot/multiboot.html

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
