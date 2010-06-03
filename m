Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476Ab0FCJqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:46:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44696 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757653Ab0FCJqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:46:31 -0400
Date: Thu, 3 Jun 2010 10:54:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>, x86@kernel.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to
 pci_reboot_dmi_table.
Message-ID: <20100603105438.7b8f3ee8@lxorguk.ukuu.org.uk>
In-Reply-To: <20100603021851.GA19546@srcf.ucam.org>
References: <4C05F3BF.6090503@gmail.com>
	<AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com>
	<4C06ECAA.3060708@gmail.com>
	<4C06ED18.2010400@gmail.com>
	<4C06F1DD.8060004@gmail.com>
	<AANLkTilQuun1jQc394YM4QZtDSVeIwh67_Np0mkRDes4@mail.gmail.com>
	<4C06F6EA.6090701@gmail.com>
	<20100603013758.GA18755@srcf.ucam.org>
	<AANLkTik1cjxh1ItnqBXaxNcwa6we7ccJJZny-mAOAUjD@mail.gmail.com>
	<4C071048.9040209@gmail.com>
	<20100603021851.GA19546@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 03:18:51 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Jun 02, 2010 at 07:15:36PM -0700, Justin P. Mattock wrote:
> > as soon as I change:
> >
> > int main() {
> > 	iopl(3);
> > 	outb(6, 0xcf9);
> > 	usleep(100);
> > 	outb(6, 0xcf9);
> > 	return 0;
> > }
> > (the above gave a command prompt
> > with numerous tries)
> 
> Ok, so it's not that straghtforward. Sigh. There's various hacky 
> workarounds we could do here, but Windows doesn't seem to do them so I 
> lean towards suspecting that there's something wrong with our keyboard 
> controller reboot mechanism. I'll try doing some more tracing.

At least some PCs you need to issue the reboot outb calls on the boot
processor so the userspace tests won't be reliable.
