Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2GQTkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:40:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51022 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab2GQTkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:40:11 -0400
Date: Tue, 17 Jul 2012 21:40:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Linux 3.5-rc7
Message-ID: <20120717194004.GA15311@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <1822123.rTBG69eEoS@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1822123.rTBG69eEoS@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 09:07:40PM +0200, Paweł Sikora wrote:
> Hi,
> 
> the modular kernel fails to build:
> 
> (...)
>   Building modules, stage 2.
>   MODPOST 3571 modules
> 
> WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x1f): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transport_exit()
> The function __init init_module() references
> a function __exit fcoe_transport_exit().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __exit annotation of
> fcoe_transport_exit() so it may be used outside an exit section.
> 
> WARNING: drivers/staging/ipack/bridges/tpci200.o(.data+0x28): Section mismatch in reference from the variable tpci200_pci_drv to the function .devexit.text:tpci200_pci_remove()
> The variable tpci200_pci_drv references
> the function __devexit tpci200_pci_remove()
> If the reference is valid then annotate the
> variable with __exit* (see linux/init.h) or name the variable:
> *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Those are section mismatch warnings, see the help to
CONFIG_DEBUG_SECTION_MISMATCH.

-- 
Regards/Gruss,
Boris.
