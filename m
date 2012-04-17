Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2DQUjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:39:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49014 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab2DQUjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:39:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
Date: Tue, 17 Apr 2012 22:43:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <4F8790F6.5080408@intel.com> <4F8CD18A.5080903@intel.com> <CAC=cRTMk-NTvo+DJ2mAq6_ZeVLbeqiGx+ttZG6Hr_hQyyYkfLw@mail.gmail.com>
In-Reply-To: <CAC=cRTMk-NTvo+DJ2mAq6_ZeVLbeqiGx+ttZG6Hr_hQyyYkfLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204172243.39525.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 17, 2012, huang ying wrote:
> On Tue, Apr 17, 2012 at 10:12 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> > On 04/17/2012 01:07 AM, Rafael J. Wysocki wrote:
> >
> >> BTW, can you please explain to me what the #WAKE signal is and how it is
> >> different from PME#?
> >
> > #WAKE signal is triggered by a pin connected to the root complex or other
> > motherboard logic. PME# is triggered by PME message sent to the port.
> 
> PME# is a PCI pin, while WAKE# is a PCI Express pin.  In PCI Express,
> there is no PME#, PME is delivered between end point device and root
> port or root complex event collector via PME message, and the PME
> message will trigger IRQ on root port or root complex event collector.
>  WAKE# is not used for PCI Express D1, D2 and D3hot, it is just used
> by D3cold.  When remote wakeup detected by end point device, it will
> assert WAKE# to notify power controller (implemented via ACPI on some
> platform), then power controller will turn on power for main link,
> after link goes back to L0, PME message will be sent to root port or
> root complex event collector by end point device.

OK

So do I understand correctly that the WAKE# signal here is the one described
in Section 5.3.3.2 Link Wakeup of PCI Express Base spec. 2.0?

So what happens is that it triggers a GPE and that GPE has a _Lxx method
associated with it, I suppose.  Is that correct?

Rafael
