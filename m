Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab0FCByO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:54:14 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:52432 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab0FCByN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=L28S3FqTjaKSyplclDZWkKa3EvzTFYjE9QZjaGBuaBzB07JcZl0YVMy6HR6JsXkpaO
         k9SwodR+x0P7HZL/8wpfYFKpvQ8pQFSuebElbNXPlK49hq6BYz1bAsNAP0C7ftMt5ZZC
         rfi81r7uBNNRlqd4jAV0WApDb5LxPC5Fk/FmU=
MIME-Version: 1.0
Date: Wed, 2 Jun 2010 21:54:11 -0400
Message-ID: <AANLkTilRZixI8TYcDAkhFXTwqxX8EeHja5Mn9JscV6nn@mail.gmail.com>
Subject: Hang during boot, bisected to commit 96d60303fd
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since somewhere early in the 2.6.35 merge window I've been seeing a
hang during boot.  The hang last roughly 30 seconds and is followed by
this:

ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
ata4.00: failed command: READ FPDMA QUEUED
ata4.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0 ncq 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: hard resetting link
ahci_is_device_present: status is: 80
ahci_is_device_present: status(2) is: 3
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: configured for UDMA/133
ata4.00: device reported invalid CHS sector 0
ata4: EH complete

The system works normally once booted.  I had some time to do a bisect
today and it cleanly ended up pointing to this commit:
    96d60303fd: ahci: Turn off DMA engines when there's no device attached

Reverting the commit makes the system boot cleanly as before.  System
has an Intel ICH10 based board, in AHCI mode, disk is an Intel X25M
SSD.

Marc
