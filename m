Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab0DAWSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:18:20 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:54286 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab0DAWSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xBq+xV6iwESMuVEnLituj8rxXY+ASa1CQRLsy3GXOWDMbdQLbr6SM/u+3QxZebc//6
         gPXWaeagVnlJzeIf6+m2XX9e2dQrqR/R4wqJLSXLhe7kyMu2PmRY9NpFCt3xYqyv73ir
         PobwPfP1WloLKkzt2vyG7zqOjyLMIyL6w1hFI=
Date: Thu, 1 Apr 2010 18:18:07 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: paragw@parag-laptop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: S2RAM broken on HP 8530p
In-Reply-To: <201004012352.18149.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1004011814140.2792@parag-laptop>
References: <alpine.DEB.2.00.1003312050370.1876@parag-laptop> <201004012208.37540.rjw@sisk.pl> <alpine.DEB.2.00.1004011725540.2043@parag-laptop> <201004012352.18149.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:

> On Thursday 01 April 2010, Parag Warudkar wrote:
> > 
> > On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:
> > 
> > > Please try:
> > > 
> > > # echo devices > /sys/power/pm_test
> > > # echo mem > /sys/power/state
> > > 
> > > and see if that breaks too (it should get back to the command line in about
> > > 5-10 seconds).
> > 
> > That breaks too - hangs similarly during suspend. I enabled RTC tracing 
> > and every time it prints out different hash matches after reboot - 
> > tty/tty21, pcie04  and latest is 
> > 
> > [    0.865296] pcieport 0000:00:1c.1: hash matches
> > 
> > Also when the suspend fails the immediate boot after that I get a USB 
> > error on startup - unable to enumerate usb device on port 1. This error is 
> > not present on normal boots.
> 
> Well, try the above with the USB controller drivers unloaded.
> 

Turns out its not the controller drivers but btusb and friends. Once I 
removed btusb,sco,bnep,l2cap and family I was able to suspend resume just 
like before.

For now I have disabled Bluetooth in BIOS as I don't need it - it is 
likely that it was disabled earlier and so the suspend/resume was 
working but looks like after a BIOS update/reset I left it enabled.

So this does not seem to be a regression to me.

But may be it should be possible to suspend/resume with bluetooth enabled? 
:)

Thanks,
Parag 
