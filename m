Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab2GGNmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 09:42:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41425 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2GGNl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 09:41:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQV5DHZoeXf-bSfuYGUSzmwtdVqGNfhHh7LJ3LBax++Rig@mail.gmail.com>
References: <Pine.LNX.4.64.1205311412210.11510@info> <CAErSpo7p6XGmsi0Q0PAbWofs9-91taz2Px=VxzL2KEoWWYJwSA@mail.gmail.com>
 <Pine.LNX.4.64.1206010915580.26561@info> <4FC988CF.5030602@gmail.com>
 <20120706180635.GB17196@google.com> <Pine.LNX.4.64.1207061631270.26974@info> <CAE9FiQV5DHZoeXf-bSfuYGUSzmwtdVqGNfhHh7LJ3LBax++Rig@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 7 Jul 2012 07:41:37 -0600
Message-ID: <CAErSpo6ukXYGUm3J25Uq5qLJPOym2sMPkWKD4QVC7CmXqhUg5w@mail.gmail.com>
Subject: Re: [Bug 43331] Re: Bug on bootup of Linux kernel on Panasonic
 Toughbook S10
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bill Unruh <unruh@physics.ubc.ca>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> because it is locked down by BIOS to chipset, readback should be 0xfed98004.
>
> and pci_size will return 32k for 0xfed98000.

A device with a read-only BAR doesn't conform to the PCI spec.  We
can't determine how much space the device consumes.
It's just an accident that BIOS put it at an address that we happen to
interpret as 32K.  We have no idea if the device consumes 4K, 8K, 16K,
or 32K.

> so try get one update bios that could return resource for root bus.
>
> or you could try to live with booting with pci=nocrs before your get new BIOS.

A BIOS update is not a useful answer.  The point is that we need
better reporting of the situation so we don't have to spend all this
time debugging this issue again.  We need to figure out how to
identify this as a non spec-compliant device and continue as best we
can.  We probably need to report it to the user because if there's a
device of unknown size consuming address space, we're liable to cause
a conflict by placing another device on top of it.
