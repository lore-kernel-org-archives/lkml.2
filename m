Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab1LORAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:00:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61607 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205Ab1LORAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9NwWetBZvU6-16rV_s5n=vrAu1kyfsbsjKh+6O2ejf9mM_ww@mail.gmail.com>
References: <CAH9NwWetBZvU6-16rV_s5n=vrAu1kyfsbsjKh+6O2ejf9mM_ww@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 15 Dec 2011 09:58:51 -0700
Message-ID: <CAErSpo4mbdaT1e2KmS2JjP1FFKfZDToXzgkb+Na_ejoo+t8snQ@mail.gmail.com>
Subject: Re: PCI(e) enumeration
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 2:41 AM, Christian Gmeiner
<christian.gmeiner@gmail.com> wrote:
> Hi all,
>
> I maintain a debian based linux RFS in my company and my college does the
> same for windows. Now we run into a problem that windows and linux use a
> different network interface as eth0. In our target system there
> are two identical NICs installed.
>
> So I am now looking to find out, how linux does the PCI enumeration
> and in which order
> the PCI driver gets called to do the initialization. Can somebody tell
> me if a depth-first search
> or a breadth-first search is done on the PCI bus.
>
>
> For instance look at this lspci output:
>
> 00:01.0 Host bridge: Advanced Micro Devices [AMD] CS5536 [Geode
> companion] Host Bridge (rev 33)
> 00:01.1 VGA compatible controller: Advanced Micro Devices [AMD] Geode LX Video
> 00:01.2 Entertainment encryption device: Advanced Micro Devices [AMD]
> Geode LX AES Security Block
> 00:04.0 Ethernet controller: Intel Corporation 8255xER/82551IT Fast
> Ethernet Controller (rev 10)
> 00:0f.0 ISA bridge: Advanced Micro Devices [AMD] CS5536 [Geode
> companion] ISA (rev 03)
> 00:0f.2 IDE interface: Advanced Micro Devices [AMD] CS5536 [Geode
> companion] IDE (rev 01)
> 00:0f.3 Multimedia audio controller: Advanced Micro Devices [AMD]
> CS5536 [Geode companion] Audio (rev 01)
> 00:0f.4 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode
> companion] OHC (rev 02)
> 00:0f.5 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode
> companion] EHC (rev 02)
> 00:0f.7 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode
> companion] UOC (rev 02)
>
> How will linux does the enumeration?

The kernel enumerates PCI devices with a depth-first traversal, but
that isn't what determines the ethX device name.  That name is
determined by the order in which network drivers are loaded and claim
devices, which gets into distro details like udev.

Here's a nice paper with more details:
http://www.dell.com/downloads/global/power/ps1q07-20060392-Domsch.pdf

If that's not enough to solve your problem, a debian-related forum
will probably be more useful than LKML.

Bjorn
