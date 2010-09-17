Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0IQPp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:45:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50702 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab0IQPp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:subject:from:to:user-agent:mime-version
         :content-type:content-transfer-encoding:x-priority:importance;
        b=EfL3NDIAEFv9FCUXE1qSn3i6jggzFFHQFXbEDf0LYLHF6SldYKC1OR6YtkDlV1lqbH
         TqKISJP7JFduFpOU8ZGmICj6w9CyvUmmpGwMyDx7qdZrgib0iPhx/UNwwX7M3VsWmuFr
         sA4fzvqvdDaIzjX7dZamhruRSp1MBeSmgMLiI=
Message-ID: <5cb62a8f48f639af132dfd4a1543750d.squirrel@localhost>
Date: Fri, 17 Sep 2010 10:45:54 -0500
Subject: Rescan/resize/reallocate PCI device BAR when it changes?
From: david.hagood@gmail.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a PCI device which can, at run time, change the size of the BARs it
makes visible (e.g. a BAR which was disabled can become enabled, a BAR
that was 64kiByte becomes 128kiByte, etc.

I would like to get the kernel to reallocate the resources for that device
without having to shut the device down and reload the device driver - the
device driver will "know" how to handle this sort of event (actually, the
driver will be the one that caused the event).

I've tried various combinations of pci_scan_bus, pci_request_resources,
etc. to no avail: I can see the hardware change size, but the kernel data
structures for the PCI device steadfastly remain unchanged.

This is a fairly common issue for us embedded programmers: we have things
like FPGAs and microprocessors as endpoints that, as the device driver
finishes programming them, will suddenly have a need for different sized
BARs.

I realize that in some cases, it may not be possible to simply resize
things (e.g. not enough resources exist within the space allocated for the
bridge the device lives on to resize things), and I am prepared to handle
such events.


