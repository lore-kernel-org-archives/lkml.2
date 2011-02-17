Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1BQLbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:31:17 -0500
Received: from www.tglx.de ([62.245.132.106]:60945 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab1BQLbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:31:14 -0500
Date: Thu, 17 Feb 2011 12:31:02 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH TIP 02/14] x86: Add device tree support
Message-ID: <20110217113102.GB11260@www.tglx.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de> <1295843342-1122-3-git-send-email-bigeasy@linutronix.de> <20110216213126.GC22837@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110216213126.GC22837@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-02-16 14:31:26 [-0700]:

>> +config X86_OF
>> +	bool "Support for device tree"
>> +	select OF
>> +	select OF_EARLY_FLATTREE
>> +	---help---
>> +	  Device tree support on X86.
>> +
>
>On ARM and MIPS, this is called 'config USE_OF'.  It would be nice to have
>some commonality.  Maybe I should move the user-visible option to
>drivers/of/Kconfig.  Or perhaps I should just make CONFIG_OF itself
>user visible.
>
>thoughts?

We could make CONFIG_OF depend on CONFIG_HAVE_OF_SUPPORT and let OF
select OF_EARLY_FLATTREE if ARCH_WANT_EARLY_FLATTREE for instance. So
that part would work in a generic way.

For OF-only platforms you would have to go to drivers/of
before you can enable the specific SoC/board. So it could lead to
something like "first enable scsi disk before you can enable usb
storage".

I like it :) For now I rename to USE_OF.

>
>g.

Sebastian
