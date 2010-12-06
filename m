Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0LFXBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:01:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44035 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab0LFXBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:01:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PRw0MwGukV5W9oRDNTVLWtynUsFjh+sL85Me6TcARQ4T7jOVTybQnI1S33KnuniF9g
         fBZskufRveh9mjxZcwzUd01SR1Bn7Djy+uslG60pQb5IeNq4nZg4e05oO99eUoiv9K24
         BGYCXZH3q9Cv8S7DAZY5N0mG39/X6lYjCvYzo=
Subject: Re: acpi_button: random oops on boot
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        richard.coe@med.ge.com, jslaby@novell.com
In-Reply-To: <201012060928.11307.bjorn.helgaas@hp.com>
References: <1291477752.5096.27.camel@Tobias-Karnat>
	 <201012060928.11307.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 00:01:43 +0100
Message-ID: <1291676503.24968.25.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 06.12.2010, 09:28 -0700 schrieb Bjorn Helgaas:
> On Saturday, December 04, 2010 08:49:12 am Tobias Karnat wrote:
> > Applying the patch from the thread, makes the problem occurring less
> > often and dmesg shows acpi-button loads for me on hid PNP0C0C and
> > LNXPWRBN.
> > 
> > Maybe commit e2fb9754d27513918a4936e8cbaad50ff56cfd3d
> > ACPI: button: remove unnecessary null pointer checks
> > has unmasked an underlying problem?
> 
> The oopses from the bugzilla are not the sort I would expect from
> a null pointer dereference, but since it's fairly reproducible for
> you, it might be worth reverting e2fb9754d27 to see whether it makes
> any difference.

I was not able to revert it.
But it would only mask the problem anyway...

I have now reverted bf04a77227db76f163bc2355ef4e176794987be2
ACPI: button: cache hid/name/class pointers and build acpi_button
as a module but this makes no difference.

> Does Rich's script from https://bugzilla.novell.com/show_bug.cgi?id=647029#c30
> help you reproduce the problem?

No, it only crashes on boot (without the printk patch).
If it happens the machine is completely dead, SysRq does not work.

However it is definitely the acpi_button module, because removing it
also fixes this.

-Tobias

