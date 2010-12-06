Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab0LFXzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:55:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49010 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab0LFXzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:55:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pM6EZWnqOqzQQlUY3L5oHKTJ1rQw6/K88Mlk6RHS3nYxgSnsdR4gY5t0OqJiqB2uTz
         xj7JtUOHPBPyGB76kWIxNviQdbfhIadESZJXXhPAKxSRgZQ/g2+7TzJbT69ZPSukM8dg
         Tj7ULw7Vs2x2DZYopn1LV128mQKqOlw2ICgRY=
Subject: Re: acpi_button: random oops on boot
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        richard.coe@med.ge.com, jslaby@novell.com
In-Reply-To: <201012061626.45962.bjorn.helgaas@hp.com>
References: <1291477752.5096.27.camel@Tobias-Karnat>
	 <201012060928.11307.bjorn.helgaas@hp.com>
	 <1291676503.24968.25.camel@Tobias-Karnat>
	 <201012061626.45962.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 00:54:59 +0100
Message-ID: <1291679699.6246.11.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 06.12.2010, 16:26 -0700 schrieb Bjorn Helgaas:
> On Monday, December 06, 2010 04:01:43 pm Tobias Karnat wrote:
> > No, it only crashes on boot (without the printk patch).
> > If it happens the machine is completely dead, SysRq does not work.
> > 
> > However it is definitely the acpi_button module, because removing it
> > also fixes this.
> 
> If it crashes on boot (not when loading an acpi_button module),
> you must be building acpi_button into the static kernel.

It does crash on boot either if built-in to the kernel or as a module,
However it does not crash if the module is loaded/unloaded after the
machine has booted.

> The acpi_button driver has a fairly complicated add() method.
> In the absence of a better idea, I might just comment out blocks
> of it and try to isolate the problem.  For example, take out
> all the input stuff, take out the wakeup GPE stuff, take out
> the type/name setup, etc.

Couldn't this be a compiler issue?
Adding some printk's to fix it seems to be insane.

-Tobias

