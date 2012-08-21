Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab2HUQzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:55:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48083 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2HUQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:55:31 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120821131115.GA3132@herton-Z68MA-D2H-B3>
References: <20120820035457.653002510@linuxfoundation.org>
	<20120820035458.292084336@linuxfoundation.org>
	<20120821051318.GB3625@herton-Z68MA-D2H-B3>
	<CAKMK7uFpj+qctqKOk6PJqRn_7XAiDbE7Bv2r2VseGyUHUTD2mA@mail.gmail.com>
	<20120821131115.GA3132@herton-Z68MA-D2H-B3>
Date: Tue, 21 Aug 2012 18:55:30 +0200
Message-ID: <CAKMK7uFjxQZYXLrs14RydnSKp6_ghwUL-1xGQm5C5dXao60Fhg@mail.gmail.com>
Subject: Re: [ 04/16] drm/i915: correctly order the ring init sequence
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 3:11 PM, Herton Ronaldo Krzesinski
<herton.krzesinski@canonical.com> wrote:
> On Tue, Aug 21, 2012 at 08:42:35AM +0200, Daniel Vetter wrote:
>> On Tue, Aug 21, 2012 at 7:13 AM, Herton Ronaldo Krzesinski
>> <herton.krzesinski@canonical.com> wrote:
>> > I had the same problem as on 3.2 with this change, i915 stopped working
>> > unable to initialize render ring, eg. on one of the boots here:
>> > [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f003 head 00001020 tail 00000000 start 00001000
>> >
>> > But unlike I was expecting as with 3.2 case, picking commit
>> > f01db988ef6f6c70a6cc36ee71e4a98a68901229 ("drm/i915: Add wait_for in
>> > init_ring_common") here isn't enough, it continues to fail even if I
>> > try to increase the delay in the wait_for, I'm not sure why yet... may
>> > be something else is going on, or 3.0 has something else missing.
>> >
>> > Also the same proposed patch for 3.4.10 gives the same problem, but
>> > picking f01db988ef6f6c70a6cc36ee71e4a98a68901229 there made things work
>> > again like happend on first 3.2.28 proposed update. Only 3.0
>> > is misteriously failing either way here.
>>
>> I guess we're missing something then still in the stable backports for
>> 3.0. Herton, what machine do you have exaclty (lspci -nn)?
>
> It's a G41 based board:

Hm, I've reviewed git log and bug reports and I have no idea what's
missing on 3.0. I guess the best course of action is to not apply this
patch to 3.0 stable - it fixes an ivb issue anyway, and 3.0 is a
rather old kernel for ivb support anyway (we generally recommend 3.2.x
for ivb).
-Daniel

>
> 00:00.0 Host bridge [0600]: Intel Corporation 4 Series Chipset DRAM Controller [8086:2e30] (rev 03)
> 00:02.0 VGA compatible controller [0300]: Intel Corporation 4 Series Chipset Integrated Graphics Controller [8086:2e32] (rev 03)
> 00:1b.0 Audio device [0403]: Intel Corporation N10/ICH 7 Family High Definition Audio Controller [8086:27d8] (rev 01)
> 00:1c.0 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 1 [8086:27d0] (rev 01)
> 00:1c.2 PCI bridge [0604]: Intel Corporation N10/ICH 7 Family PCI Express Port 3 [8086:27d4] (rev 01)
> 00:1d.0 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #1 [8086:27c8] (rev 01)
> 00:1d.1 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #2 [8086:27c9] (rev 01)
> 00:1d.2 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #3 [8086:27ca] (rev 01)
> 00:1d.3 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB UHCI Controller #4 [8086:27cb] (rev 01)
> 00:1d.7 USB Controller [0c03]: Intel Corporation N10/ICH 7 Family USB2 EHCI Controller [8086:27cc] (rev 01)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev e1)
> 00:1f.0 ISA bridge [0601]: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge [8086:27b8] (rev 01)
> 00:1f.2 IDE interface [0101]: Intel Corporation N10/ICH7 Family SATA IDE Controller [8086:27c0] (rev 01)
> 00:1f.3 SMBus [0c05]: Intel Corporation N10/ICH 7 Family SMBus Controller [8086:27da] (rev 01)
> 02:00.0 Ethernet controller [0200]: Atheros Communications AR8151 v1.0 Gigabit Ethernet [1969:1073] (rev c0)
>
>>
>> Greg, I think for now it's better if you hold off on merging this
>> patch to 3.0 until this is sorted out.
>>
>> Thanks, Daniel
>> --
>> Daniel Vetter
>> daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>>
>
> --
> []'s
> Herton



-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
