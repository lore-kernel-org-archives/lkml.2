Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718Ab0I0Ppz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:45:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32786 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759707Ab0I0Ppy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:45:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dx1T7JiWoS30GzKkw0F9CfEeVE7PqrKlPODM2grQgY7/fUk/ypMPhs4ssF6tF/53ED
         8sQ4N3nZ7Cr+V61WT8y+4bMva7Zob58/+utrxa8MvheP+8UcZwvBLQdDt//CD8sZ/4u4
         OsREa2z4qcc3tNFxDUqYa7eqfi4MRUgSfpQ4U=
MIME-Version: 1.0
In-Reply-To: <1285524744.2277.41.camel@morgan.silverblock.net>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	<AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	<1285023750.30856.99.camel@morgan.silverblock.net>
	<AANLkTi=RCJcQMSWMm6pQgJnJZT9TyfGyFtWmeu8GKHA-@mail.gmail.com>
	<1285090202.19131.77.camel@morgan.silverblock.net>
	<AANLkTi=h=9mvdLMcZZAtg3_eu7wD2Yj0Dn2iWjhF7BiL@mail.gmail.com>
	<AANLkTi=2E4LqbFKd6fq+dn3q+fau1Zt+-4nuigv7VA45@mail.gmail.com>
	<1285189645.14364.55.camel@morgan.silverblock.net>
	<AANLkTin1WF86M0D9qMGb47SghJG7D_dnsBUgmCt3kirH@mail.gmail.com>
	<1285524744.2277.41.camel@morgan.silverblock.net>
Date: Mon, 27 Sep 2010 11:45:52 -0400
Message-ID: <AANLkTinkSDFot-_UPfA3Gvh9qJPMwO3Rdt_WFGF1z+7x@mail.gmail.com>
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS polling
From: Alex Deucher <alexdeucher@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jon Smirl <jonsmirl@gmail.com>,
        =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 2:12 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Fri, 2010-09-24 at 15:12 -0400, Alex Deucher wrote:
>> On Wed, Sep 22, 2010 at 5:07 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> > On Wed, 2010-09-22 at 09:33 -0400, Jon Smirl wrote:
>> >> On Wed, Sep 22, 2010 at 1:30 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> >> > On Tue, Sep 21, 2010 at 1:30 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> >> >> On Tue, 2010-09-21 at 00:26 -0400, Alex Deucher wrote:
>> >> >>> 2010/9/20 Andy Walls <awalls@md.metrocast.net>:
>> >> >>> > On Mon, 2010-09-20 at 20:29 +0200, Rafał Miłecki wrote:
>> >> >>> >> 2010/9/20 Andy Walls <awalls@md.metrocast.net>:
>> >
>> >> >> The real problem to me is that the radeon and drm modules have a single,
>> >> >> standard way of dealing with EDID errors.  However, EDID errors can
>> >> >> happen due to a number of different causes, some of which are external
>> >> >> (i.e. in the LCD or CRT monitor).  Given that, there really is no "right
>> >> >> thing" the drivers can do without input from the user on what the policy
>> >> >> should be when a bad EDID is detected.
>> >>
>
>
>> The attached patch should fix up your board.  Let me know if it works for you.
>
> That patch suppresses the setup of the HDMI and DVI connectors that
> don't exist, so the log spam from polling for EDID's is gone for me.
>
>        [PATCH] drm/radeon/kms: add quirk for MSI K9A2GM motherboard
>
>        Board has no digital connectors
>
>        Reported-by: Andy Walls <awalls@md.metrocast.net>
>        Tested-by: Andy Walls <awalls@md.metrocast.net>
>        Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
>        Cc: stable@kernel.org
>

Thanks,  I've sent this to Dave.

>
> Yes it works for me, but it's what I'd call a "point solution".  There
> are still these which appear to be the exact same symptoms (perpetual
> EDID log spam) just for different hardware setups:
>
>        https://bugs.freedesktop.org/show_bug.cgi?id=27708
>        https://partner-bugzilla.redhat.com/show_bug.cgi?id=610362
>
>
> Here was a broader solution for a particular class of machines (Laptops
> with i915 chips with an LVDS with a broken EDID) exhibiting those same
> symptoms:
>
>        https://patchwork.kernel.org/patch/83556/
>
> Picking these bugs off one or two at a time, as users report the same
> symptoms over an over again, is really a waste of users' time.  Users
> wait while their report is queued, a custom kernel patch developed, and
> a kernel patch makes it through their distro to them.
>

These are two different issues.  The board needs a quirk to fix up the
bogus connectors regardless of the edid crap.  As to what to do about
the edid stuff, I'd personally prefer we just silence most of the
warnings or at least just warn once.  I think we are a bit too
pedantic about edid errors in general.  I think a good rule of thumb
would be to drop an edid if it doesn't have a valid header, but use it
if it's valid, but has something like a bad checksum or extension
block problems.

>
> On a different subject, with your patch applied, I'm now seeing a new
> error message in my log that I have not seen before:
>
>        failed to evaluate ATIF got AE_BAD_PARAMETER
>
> Here's the dmesg from drm:
>
>        [drm] Initialized drm 1.1.0 20060810
>        [drm] radeon defaulting to kernel modesetting.
>        [drm] radeon kernel modesetting enabled.
>        radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>        [drm] initializing kernel modesetting (RS740 0x1002:0x796E).
>        [drm] register mmio base: 0xFE7F0000
>        [drm] register mmio size: 65536
>        ATOM BIOS: ATI
>        radeon 0000:01:05.0: VRAM: 128M 0x78000000 - 0x7FFFFFFF (128M used)
>        radeon 0000:01:05.0: GTT: 512M 0x80000000 - 0x9FFFFFFF
>        [drm] radeon: irq initialized.
>        [drm] Detected VRAM RAM=128M, BAR=128M
>        [drm] RAM width 128bits DDR
>        [TTM] Zone  kernel: Available graphics memory: 963022 kiB.
>        [TTM] Initializing pool allocator.
>        [drm] radeon: 128M of VRAM memory ready
>        [drm] radeon: 512M of GTT memory ready.
>        [drm] GART: num cpu pages 131072, num gpu pages 131072
>        [drm] radeon: 1 quad pipes, 1 z pipes initialized.
>        [drm] Loading RS690/RS740 Microcode
>        [drm] radeon: ring at 0x0000000080000000
>        [drm] ring test succeeded in 1 usecs
>        [drm] radeon: ib pool ready.
>        [drm] ib test succeeded in 0 usecs
>        [drm] Enabling audio support
>        failed to evaluate ATIF got AE_BAD_PARAMETER
>        [drm] Default TV standard: NTSC
>        [drm] Radeon Display Connectors
>        [drm] Connector 0:
>        [drm]   VGA
>        [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 0x7e5c 0x7e4c
>        [drm]   Encoders:
>        [drm]     CRT1: INTERNAL_KLDSCP_DAC1
>        [drm] fb mappable at 0xD8040000
>        [drm] vram apper at 0xD8000000
>        [drm] size 4325376
>        [drm] fb depth is 24
>        [drm]    pitch is 5632
>        fbcon: radeondrmfb (fb0) is primary device
>        Console: switching to colour frame buffer device 170x48
>        fb0: radeondrmfb frame buffer device
>        drm: registered panic notifier
>        Slow work thread pool: Starting up
>        Slow work thread pool: Ready
>        [drm] Initialized radeon 2.6.0 20080528 for 0000:01:05.0 on minor 0
>
>
> By inspection of the code, it looks like the handle being passed into
> radeon_atif_call() by radeon_acpi_init() may be bad.  I'm not sure why
> that would be though.
>
> I won't have time until Thursday to run it down any further.

Does your board actually have the ATIF method?  I think your board is
probably too old.  Newer kernels should only warn when the method is
present and there's an error.  The method really only exists on newer
laptops as far as I know.

Alex

>
> Regards,
> Andy
>
>> Thanks,
>>
>> Alex
>
>
>
