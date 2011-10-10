Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1JJVI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:08:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46970 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1JJVI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:08:57 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: Linux 3.1-rc9
Date: Mon, 10 Oct 2011 23:08:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9-00064-g65112dc-dirty; KDE/4.7.2; x86_64; ; )
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <4E9329BC.8030704@linux.vnet.ibm.com> <201110101957.25322.a.miskiewicz@gmail.com>
In-Reply-To: <201110101957.25322.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110102308.43145.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 of October 2011, Arkadiusz Miśkiewicz wrote:
> On Monday 10 of October 2011, Stefan Berger wrote:
> > On 10/10/2011 01:05 PM, Arkadiusz Miśkiewicz wrote:
> > > On Monday 10 of October 2011, Rajiv Andrade wrote:
> > >> On 09/10/11 23:29, Stefan Berger wrote:
> > >>> On 10/09/2011 04:51 PM, Arkadiusz Miśkiewicz wrote:
> > >>>> On Wednesday 05 of October 2011, Linus Torvalds wrote:
> > >>>>> Another week, another -rc.
> > >>>> 
> > >>>> suspend to ram regression is annoying (still visible on rc9;
> > >>>> https://lkml.org/lkml/2011/9/24/76) but unfortunately maintainers
> > >>>> are silent.
> > >>> 
> > >>> I tried -rc9 on my Lenovo W500 with that same TPM. I cannot reproduce
> > >>> the 'scheduling while atomic' problem you had reported earlier. I
> > >>> also could suspend / resume fine as long as I did the following:
> > >>> 
> > >>> - suspended with the tpm_tis driver as module in the kernel
> > >>> - once a suspend was done without the tpm_tis driver the subsequent
> > >>> suspends were all done without the tpm_tis driver
> > >>> 
> > >>> Once I had done a suspend/resume with the tpm_tis driver *not* in the
> > >>> kernel and then again a suspend with the tpm_tis driver in the
> > >>> kernel, it did not resume anymore. I believe previously (previous
> > >>> version of kernel and/or Fedora) it refused to even suspend. The
> > >>> reason why this doesn't work properly is that the driver has to send
> > >>> a command to the TPM upon suspend and the BIOS then sends the
> > >>> corresponding wakeup command.
> > >>> 
> > >>> Did you maybe previously suspend/resume without a tpm_tis driver and
> > >>> then try to suspend with it ?
> > >>> 
> > >>> Also, my Lenovo W500 shows particularly odd behavior when I switch
> > >>> from Windows to Linux. The first suspend with a Linux booted after
> > >>> Windows (with or without tpm_tis driver) does *not* resume (reboot
> > >>> required). A subsequently rebooted Linux makes the suspend/resume
> > >>> work fine.
> > >>> 
> > >>>     Stefan
> > >> 
> > >> Arkadiusz,
> > >> 
> > >> Do you still see the issue with this patch [1][2] applied?
> > > 
> > > The issue doesn't happen with this patch but error condition with
> > > "Could not read PCR 0. TPM is not working correctly." is triggered
> > > immediately at boot, even before suspend is used.
> > > 
> > > $ dmesg|grep -iE "(tpm|suspend)"
> > > [   12.640039] tpm_tis 00:0a: 1.2 TPM (device-id 0x1020, rev-id 6)
> > > [   12.640048] tpm_tis 00:0a: Intel iTPM workaround enabled
> > > [   12.768057] tpm_tis 00:0a: Could not read PCR 0. TPM is not working
> > > correctly.
> > > [   12.768066] tpm_tis 00:0a: Was machine previously suspended without
> > > TPM driver present?
> > > [   88.512117] Suspending console(s) (use no_console_suspend to debug)
> > 
> > Though I suppose that now your suspend/resume cycles always work?
> 
> Tried several times and it always worked, so probably yes. Longer testing
> will give definitive answer.
> 
> > I guess the BIOS seems not to be initializing the TPM correctly. Any
> > chance you can get a hold of a BIOS update for your machine?
> 
> Then I looked into bios options on this thinkpad t400 and there are 3
> possible TPM settings: Enabled, Invisible, Disabled.
> 
> Invisible is - visible but not working - according to bios help. No idea
> why such option exists but I had it enabled.
> 
> Right now I've set that to "Enabled" and ran few suspend/resume cycles - no
> problems so far.

Unfortunately TPM enabled in bios + kernel (3.1.0-rc9-00064-g65112dc-dirty) 
with the patch applied

[11629.922643] legacy_resume(): pnp_bus_resume+0x0/0x67 returns -19
[11629.922646] PM: Device 00:0a failed to resume: error -19


and there is no "Could not read PCR 0. TPM is not working correctly." message, 
so this check  doesn't seem to be good enough.

> 
> I guess there is some way to make "Invisible" mode properly handled in
> Linux, too.
> 
> >     Stefan


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
