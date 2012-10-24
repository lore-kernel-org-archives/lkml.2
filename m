Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101Ab2JXTlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:41:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63639 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2JXTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:41:18 -0400
Date: Wed, 24 Oct 2012 12:41:14 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com,
        "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC/PATCH 2.6.32.y 0/3] Re: [stable 2.6.32..2.6.34] x86, ioapic:
 initialize nr_ioapic_registers early in mp_register_ioapic()
Message-ID: <20121024194114.GC3120@elie.Belkin>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
 <20121024182546.GB3338@elie.Belkin>
 <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Wed, 2012-10-24 at 11:25 -0700, Jonathan Nieder wrote:

>> Why not cherry-pick 7716a5c4ff5 in full?
>
> As that depends on the other commits like:
> commit 4b6b19a1c7302477653d799a53d48063dd53d555

More importantly, if I understand correctly it might depend on

 commit cf7500c0ea13
 Author: Eric W. Biederman <ebiederm@xmission.com>
 Date:   Tue Mar 30 01:07:11 2010 -0700

     x86, ioapic: In mpparse use mp_register_ioapic

Here's a series, completely untested, that is closer to what I
expected.  But the approach you took seems reasonable, too, as long
as the commit message is tweaked to explain it.

Thanks again,
Jonathan

Eric W. Biederman (3):
  x86, ioapic: Teach mp_register_ioapic to compute a global gsi_end
  x86, ioapic: In mpparse use mp_register_ioapic
  x86, ioapic: Move nr_ioapic_registers calculation to
    mp_register_ioapic.

 arch/x86/include/asm/io_apic.h |  1 +
 arch/x86/kernel/apic/io_apic.c | 28 ++++++++++++++--------------
 arch/x86/kernel/mpparse.c      | 25 +------------------------
 arch/x86/kernel/sfi.c          |  4 +---
 4 files changed, 17 insertions(+), 41 deletions(-)
