Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1ALS3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:29:38 -0500
Received: from www.tglx.de ([62.245.132.106]:45560 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1ALS3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:29:36 -0500
Date: Wed, 12 Jan 2011 19:29:29 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com
Subject: Re: [PATCH v2 13/15] x86/rtc: don't register rtc if we the DT blob
Message-ID: <20110112182929.GC6907@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-14-git-send-email-bigeasy@linutronix.de> <20101230085940.GG11721@angua.secretlab.ca> <20110104132846.GC21359@www.tglx.de> <20110112000224.GI2131@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110112000224.GI2131@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2011-01-11 17:02:24 [-0700]:

>> +static __init int have_DTB(void)
>> +{
>> +	if (initial_boot_params)
>> +		return 1;
>> +	return 0;
>> +}

>Not quite the right test.  For instance, OLPC has real openfirmware so
>initial_boot_params will be zero even though there is a fully
>populated device tree.  Should test the allnodes value instead.
Oh really? They do have a device tree and their initial_boot_params is
NULL? I assumed they boot via OF but I saw no evidence of the device
tree as it. In fact I noticed that they have a static PCI bus living in
arch/x86 and I assumed that is the place where their devices are comming
from.
However, this _could_ change the behavior of OLPC and they could lack an
RTC now if it is not comming via isa_pnp thing or via the device tree
(which had no bindings until recently).

>Also, this test is useful to more than just rtc I'm sure.  It could
>easily live in linux/of.h.
Okay.

>Finally one minor nit.  This is more verbose than it needs to be.  It
>could instead be:  "return allnodes != NULL;", and the __init is
>unnecessary on a static inline.

Okay. The static line has no __init just the non inline has __init :)

>g.

Sebastian
