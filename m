Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2E3Mnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:43:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49369 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2E3Mni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:43:38 -0400
Date: Wed, 30 May 2012 14:43:33 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Comrade DOS <suloevdmitry@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Performance drop
Message-ID: <20120530124333.GA3008@alberich.amd.com>
References: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com>
 <20120524123116.GA4048@alberich.amd.com>
 <CA+fU7qfPznJpRABC4Z=xmRZW6p5Mw3dFLBySk9HuPnaCYMMnEg@mail.gmail.com>
 <20120529140940.GA10421@alberich.amd.com>
 <CA+fU7qdKYA3KJr3xET_evO_1ztSKh0K0csn5Coro7Mkv_my+eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fU7qdKYA3KJr3xET_evO_1ztSKh0K0csn5Coro7Mkv_my+eg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 03:20:27AM +0700, Comrade DOS wrote:
> > Unfortunately you have used acpi=debug instead of apic=debug.  So I
> > can't compare I/O APIC configurations between the different test
> > scenarios.
> 
> Sorry me for this mistake.

No problem.

The logs show no difference in IO-APIC pin usage.
So it's not the old problem ...

Comparing both logs I found following differences:

(Most other stuff seems just to be changed formatting.)

-ACPI: Thermal Zone [TZ1] (67 C)
+ACPI: Thermal Zone [TZ1] (62 C)

I think what's shown is the temperature value which just differed
between the boots. But that made me look at acpi/thermal.c where the
messages came from. The only change between 3.3 and 3.4 is this
commit:

  commit 9bcb8118965ab4631a65ee0726e6518f75cda6c5
  Author: Matthew Garrett <mjg@redhat.com>
  Date:   Wed Feb 1 10:26:54 2012 -0500

    ACPI: Evaluate thermal trip points before reading temperature

I'd suggest to do a test with this patch reverted.  Maybe this change
to fix issues with one HP Laptop (re-)intruduced the trouble with your
system.

If reverting the patch helps we have to take a closer look at your
ACPI tables.  So can you please do a

 # git revert 9bcb8118965ab4631a65ee0726e6518f75cda6c5

on top of v3.4 and rebuid your kernel and rerun your test (with
apic=debug. This allows easier diff to dmesg output of your previous
test runs).

In any case it also would be good to have the acpi tables from your
system. So please also use
# acpidump >acpidump.3.3    (using the 3.3.x kernel)
# acpidump >acpidump.3.4    (using the unmodified 3.4 version)

and send all files as attachments to your mail.

This will allow me to look at your thermal zone definitions in the
working and non-working case.


Thanks,

Andreas
