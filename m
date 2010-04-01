Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab0DARxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:53:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35928 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab0DARxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=an4vhmfOt2xCG7w8MA4ALnky4f6LZex2bVWTRy0jWbdpXS8DDmU1tGqMjuhoyCqyIM
         CBi1zbim/zrEyj24zeOaHMHZIxknM6NUx/7dymcQEJaRuo1N+/7Ut2s25YmkQYUit/ej
         YpsRCJitH2teSIYnQhW5RYyJ6y71RX8cq8SBc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004011019270.3707@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	 <201003302316.45651.rjw@sisk.pl> <201004010313.32920.rjw@sisk.pl>
	 <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
	 <o2ma728f9f91004011007l4c3aee18p14daae06cda71e68@mail.gmail.com>
	 <alpine.LFD.2.00.1004011019270.3707@i5.linux-foundation.org>
Date: Thu, 1 Apr 2010 13:53:10 -0400
Message-ID: <i2ga728f9f91004011053u75097a2n3706f946dfd8f6fb@mail.gmail.com>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 
	(was: Re: Linux 2.6.34-rc3)
From: Alex Deucher <alexdeucher@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 1:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 1 Apr 2010, Alex Deucher wrote:
>>
>> Clemems' "PCI quirk: RS780/RS880: disable MSI completely" patch is the
>> right approach I think.  Note that it's only devices hung off the int
>> gfx pci to pci bridge that have broken MSI (gfx and audio).  MSI works
>> fine on the PCIE slots.  I have a similar patch for rs400 chips on bug
>> 15626:
>> https://bugzilla.kernel.org/show_bug.cgi?id=15626
>
> Hmm. Does 'pci_msi_enable' only cover regular PCI devices? Or will that
> pci_no_msi() quirk disable MSI for PCIE too? I think it will trigger for
> PCIE drivers too.
>
> Put another way: it sounds like the quirk now disables MSI for all
> devices. Maybe there would some more targeted mode?
>

What I meant to say was MSI works fine on bridges other than the
bridge the internal gfx lives on.  quirk_disable_msi() just disables
MSI on the devices on that particular bridge as far as I understand
it, but I'm by no means an expert on the PCI code.  E.g., on my RS780
board, MSIs are only problematic on the integrated gfx chip.  MSIs
work fine on PCI/PCIE add-on cards and the integrated Ethernet.

Alex

>                Linus
>
