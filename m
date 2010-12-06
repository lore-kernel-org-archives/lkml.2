Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0LFX05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:26:57 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1872 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab0LFX0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:26:55 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Subject: Re: acpi_button: random oops on boot
Date: Mon, 6 Dec 2010 16:26:45 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        richard.coe@med.ge.com, jslaby@novell.com
References: <1291477752.5096.27.camel@Tobias-Karnat> <201012060928.11307.bjorn.helgaas@hp.com> <1291676503.24968.25.camel@Tobias-Karnat>
In-Reply-To: <1291676503.24968.25.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061626.45962.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 06, 2010 04:01:43 pm Tobias Karnat wrote:
> Am Montag, den 06.12.2010, 09:28 -0700 schrieb Bjorn Helgaas:
> > On Saturday, December 04, 2010 08:49:12 am Tobias Karnat wrote:
> > > Applying the patch from the thread, makes the problem occurring less
> > > often and dmesg shows acpi-button loads for me on hid PNP0C0C and
> > > LNXPWRBN.
> > > 
> > > Maybe commit e2fb9754d27513918a4936e8cbaad50ff56cfd3d
> > > ACPI: button: remove unnecessary null pointer checks
> > > has unmasked an underlying problem?
> > 
> > The oopses from the bugzilla are not the sort I would expect from
> > a null pointer dereference, but since it's fairly reproducible for
> > you, it might be worth reverting e2fb9754d27 to see whether it makes
> > any difference.
> 
> I was not able to revert it.
> But it would only mask the problem anyway...

Right, but now the granularity is "remove the acpi_button driver
completely."  If we can identify a specific statement inside
acpi_button that makes a difference, that might help.

> I have now reverted bf04a77227db76f163bc2355ef4e176794987be2
> ACPI: button: cache hid/name/class pointers and build acpi_button
> as a module but this makes no difference.
> 
> > Does Rich's script from https://bugzilla.novell.com/show_bug.cgi?id=647029#c30
> > help you reproduce the problem?
> 
> No, it only crashes on boot (without the printk patch).
> If it happens the machine is completely dead, SysRq does not work.
> 
> However it is definitely the acpi_button module, because removing it
> also fixes this.

If it crashes on boot (not when loading an acpi_button module),
you must be building acpi_button into the static kernel.

The acpi_button driver has a fairly complicated add() method.
In the absence of a better idea, I might just comment out blocks
of it and try to isolate the problem.  For example, take out
all the input stuff, take out the wakeup GPE stuff, take out
the type/name setup, etc.

Bjorn
