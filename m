Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0LFQ2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:28:21 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:4213 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFQ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:28:20 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Subject: Re: acpi_button: random oops on boot
Date: Mon, 6 Dec 2010 09:28:11 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        richard.coe@med.ge.com, jslaby@novell.com
References: <1291477752.5096.27.camel@Tobias-Karnat>
In-Reply-To: <1291477752.5096.27.camel@Tobias-Karnat>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012060928.11307.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 04, 2010 08:49:12 am Tobias Karnat wrote:
> I have a problem with random oopses on boot,
> every 1 out of 5 times I boot linux freezes.
> 
> I was not able to obtain a call trace, however it happens around 10-15
> seconds after boot. I can hear that the tg3 driver is initialised.
> 
> In this thread, they have the same problem:
> https://bugzilla.novell.com/show_bug.cgi?id=647029

Wow, that's a nasty problem.

> Applying the patch from the thread, makes the problem occurring less
> often and dmesg shows acpi-button loads for me on hid PNP0C0C and
> LNXPWRBN.
> 
> Maybe commit e2fb9754d27513918a4936e8cbaad50ff56cfd3d
> ACPI: button: remove unnecessary null pointer checks
> has unmasked an underlying problem?

The oopses from the bugzilla are not the sort I would expect from
a null pointer dereference, but since it's fairly reproducible for
you, it might be worth reverting e2fb9754d27 to see whether it makes
any difference.

Does Rich's script from https://bugzilla.novell.com/show_bug.cgi?id=647029#c30
help you reproduce the problem?

Bjorn
