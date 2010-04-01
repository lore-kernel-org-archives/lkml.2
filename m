Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab0DAVAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:00:13 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49808 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0DAVAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EHlC59n8qClWlUeet1GJCq3TSJuhB1vf5m0YdnvUwTHAfO6sWq7id6Qa25B25rjLEt
         X2GZFfphwOvzalAARQ6aO80L2eKOLLfpiYx8K8xo0HQEMRZ4Wz2lRwyUJdQdfiYMovt8
         S/IFJrLTSAlRwiw6rE7ptfsFpcxkBjzPZikew=
MIME-Version: 1.0
In-Reply-To: <201004012248.38794.rjw@sisk.pl>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	 <201004012228.06938.rjw@sisk.pl>
	 <g2ka728f9f91004011339o49bfe665od525acc1464cbdb@mail.gmail.com>
	 <201004012248.38794.rjw@sisk.pl>
Date: Thu, 1 Apr 2010 17:00:04 -0400
Message-ID: <u2ra728f9f91004011400p2d963f30x4f6d89d8b4410c97@mail.gmail.com>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 
	(was: Re: Linux 2.6.34-rc3)
From: Alex Deucher <alexdeucher@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org,
       Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 4:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 01 April 2010, Alex Deucher wrote:
>> On Thu, Apr 1, 2010 at 4:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Thursday 01 April 2010, Alex Deucher wrote:
>> >> On Thu, Apr 1, 2010 at 2:36 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
>> >> > Alex Deucher wrote:
>> >> >> On Wed, Mar 31, 2010 at 9:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >>> On Tuesday 30 March 2010, Rafael J. Wysocki wrote:
>> >> >>>> >       PCI quirk: RS780/RS880: work around missing MSI initialization
>> >> >>>>
>> >> >>>> This one (commit a5ee4eb7541) broke OpenGL acceleration on my new test box
>> >> >>>> which happens to have a RS780.
>> >> >
>> >> > So it's better to disable MSI unconditionally.
>> >> >
>> >> > Rafael, can you check if MSI works for the HDMI audio device?
>> >> > (I'd guess it doesn't.)
>> >> >
>> >> >> I also have the attached patch queued in via Dave's tree to disable
>> >> >> MSI on all IGP chips for the time being.
>> >> >
>> >> > This disables MSI only for the graphics device.  I'd prefer to have
>> >> > the quirk on its bridge so that MSI gets disabled for the HDMI audio
>> >> > device too, to avoid having to duplicate this quirk in the snd-hda-intel
>> >> > driver.
>> >> >
>> >> > ==========
>> >> >
>> >> > PCI quirk: RS780/RS880: disable MSI completely
>> >> >
>> >> > The missing initialization of the nb_cntl.strap_msi_enable does not seem
>> >> > to be the only problem that prevents MSI, so that quirk is not
>> >> > sufficient to enable MSI on all machines.  To be safe, unconditionally
>> >> > disable MSI for the internal graphics and HDMI audio on these chipsets.
>> >> >
>> >> > Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
>> >>
>> >> Works fine here.
>> >>
>> >> Tested-by: Alex Deucher <alexdeucher@gmail.com>
>> >
>> > Unfortunately it doesn't work for me without the
>> >
>> > if ((rdev->family >= CHIP_RV380) &&
>> >            (!(rdev->flags & RADEON_IS_IGP)))
>> >
>> > radeon quirk.
>>
>> what are your pci ids?
>
> 1022:960b
>
> I guess 1022 is AMD.
>
> OK, I'll try to add that.

0x960b won't affect the internal gfx.  That bridge is for the pcie x16 gfx slot.

0x9600                       Host bridge
0x9602                       Internal GFX PCI-PCI bridge ID
0x9603                       External GFX - port 0
0x960B                       External GFX - port 1
0x9604                       PCI-PCI bridge - Port 0
0x9605                       PCI-PCI bridge - Port 1
0x9606                       PCI-PCI bridge - Port 2
0x9607                       PCI-PCI bridge - Port 3
0x9608                       PCI-PCI bridge - Port 4
0x9609                       PCI-PCI bridge - Port 5
0x960A                       PCI-PCI bridge (SB)
0x960F                       HD Audio controller
0x791A                       HDMI Audio codec

Alex

>
> Rafael
>
