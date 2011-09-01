Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab1IAFQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 01:16:04 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:37028 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000Ab1IAFQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 01:16:01 -0400
Date: Thu, 1 Sep 2011 01:15:58 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux v2.20
Message-ID: <20110901051558.GA14777@elliptictech.com>
References: <20110829122344.GI1855@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829122344.GI1855@nb.net.home>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karel,

On 2011-08-29 14:23 +0200, Karel Zak wrote:
> The stable util-linux 2.20 release is available at
> 
>    ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.20/
> 
> Feedback and bug reports, as always, are welcomed.

Just upgraded on one of my machines today, and I was surprised to
discover that only a small portion of my kernel log was printed by
dmesg.  "busybox dmesg" and "dmesg -r" both print the full log (~2000
lines), but plain "dmesg" prints only the first ~150 lines or so.  2.19
dmesg worked fine.

The last few lines printed by plain "dmesg" are:

  [...]
  ACPI: Added _OSI(Module Device)
  ACPI: Added _OSI(Processor Device)
  ACPI: Added _OSI(3.0 _SCP Extensions)
  ACPI: Added _OSI(Processor Aggregator Device)
  ACPI: EC: Look up EC in DSDT
  ACPI: Executed 1 blocks of module-level executable AML code
  ACPI: Actual Package length (234) is larger than NumElements field (3), truncated

Adding the -r option gives much more:

  [...]
  <6>ACPI: Added _OSI(Module Device)
  <6>ACPI: Added _OSI(Processor Device)
  <6>ACPI: Added _OSI(3.0 _SCP Extensions)
  <6>ACPI: Added _OSI(Processor Aggregator Device)
  <7>ACPI: EC: Look up EC in DSDT
  <4>ACPI: Executed 1 blocks of module-level executable AML code
  <4>ACPI: Actual Package length (234) is larger than NumElements field (3), truncated
  <4>
  <6>ACPI: Interpreter enabled
  <6>ACPI: (supports S0 S5)
  <6>ACPI: Using IOAPIC for interrupt routing
  <6>ACPI: Power Resource [ISAV] (on)
  <6>ACPI: No dock devices found.
  [...]

So it looks like it's tripping over the blank line in the log?

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
