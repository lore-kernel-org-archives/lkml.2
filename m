Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab0FCB5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:57:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38316 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab0FCB5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:57:08 -0400
Date: Thu, 3 Jun 2010 02:56:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, x86@kernel.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
	pci_reboot_dmi_table.
Message-ID: <20100603015659.GA19123@srcf.ucam.org>
References: <4C05E800.1010400@gmail.com> <4C05F3BF.6090503@gmail.com> <AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com> <4C06ECAA.3060708@gmail.com> <4C06ED18.2010400@gmail.com> <4C06F1DD.8060004@gmail.com> <AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com> <4C06F6EA.6090701@gmail.com> <20100603013758.GA18755@srcf.ucam.org> <AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 07:47:17PM -0600, Robert Hancock wrote:
> On Wed, Jun 2, 2010 at 7:37 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > That's pretty infuriating. The ACPI-provided definition doesn't work,
> > and there's no ACPI mechanism for expressing the more complex cf9
> > behaviour. Windows doesn't appear to special case this, so we're
> > probably left trying to figure out why the keyboard controller method
> > doesn't work. Sigh.
> 
> Do these Macs even have a PC keyboard controller? A recent thread on
> PS/2 keyboard/mouse controller probing suggests they may not..

Possibly an SMM trap...

> Justin, what happens if you try the simple outb(6, 0xcf9) test program
> multiple times, does that do anything?

Huh. That might work, yes. Windows does the ACPI write, an i8042 write, 
the ACPI write, another i8042 write and then gives up. If that happens 
sufficiently quickly, this might get us somewhere. Justin, can you try:

#include <sys/io.h>
#include <unistd.h>

int main() {
	iopl(3);
	outb(6, 0xcf9);
	usleep(100);
	outb(6, 0xcf9);
	return 0;
}

and see if that reboots?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
