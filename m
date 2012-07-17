Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab2GQTRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:17:16 -0400
Received: from mail.agmk.net ([91.192.224.71]:35352 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374Ab2GQTRO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:17:14 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2012 15:17:14 EDT
From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: Re: Linux 3.5-rc7
Date: Tue, 17 Jul 2012 21:07:40 +0200
Message-ID: <1822123.rTBG69eEoS@localhost>
User-Agent: KMail/4.8.3 (Linux/3.4.4-1; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the modular kernel fails to build:

(...)
  Building modules, stage 2.
  MODPOST 3571 modules

WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x1f): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit()
The function __init init_module() references
a function __exit fcoe_transport_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
fcoe_transport_exit() so it may be used outside an exit section.

WARNING: drivers/staging/ipack/bridges/tpci200.o(.data+0x28): Section mismatch in reference from the variable tpci200_pci_drv to the function .devexit.text:tpci200_pci_remove()
The variable tpci200_pci_drv references
the function __devexit tpci200_pci_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console


BR,
Paweł.

