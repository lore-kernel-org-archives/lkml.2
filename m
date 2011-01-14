Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1ANWQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:16:59 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52563 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1ANWQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:16:58 -0500
MIME-Version: 1.0
In-Reply-To: <20110112182929.GC6907@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-14-git-send-email-bigeasy@linutronix.de>
 <20101230085940.GG11721@angua.secretlab.ca> <20110104132846.GC21359@www.tglx.de>
 <20110112000224.GI2131@angua.secretlab.ca> <20110112182929.GC6907@www.tglx.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Jan 2011 15:16:37 -0700
X-Google-Sender-Auth: kMnGgIaVaI0Oev6QECFHJlrN7Fw
Message-ID: <AANLkTikFzAy2WFZWwmWkQD5fNk4733H+8-0a4xx61saL@mail.gmail.com>
Subject: Re: [PATCH v2 13/15] x86/rtc: don't register rtc if we the DT blob
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 11:29 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> * Grant Likely | 2011-01-11 17:02:24 [-0700]:
>
>>> +static __init int have_DTB(void)
>>> +{
>>> +    if (initial_boot_params)
>>> +            return 1;
>>> +    return 0;
>>> +}
>
>>Not quite the right test.  For instance, OLPC has real openfirmware so
>>initial_boot_params will be zero even though there is a fully
>>populated device tree.  Should test the allnodes value instead.
> Oh really? They do have a device tree and their initial_boot_params is
> NULL? I assumed they boot via OF but I saw no evidence of the device
> tree as it. In fact I noticed that they have a static PCI bus living in
> arch/x86 and I assumed that is the place where their devices are comming
> from.

I'm not sure how much of it has gone upstream yet (some stuff is going
via tip tree), but when OLPC device tree support gets fully merged, it
will be creating the live tree by poking OFW directly like Sparc does.
 It will not generate a flattree first like PowerPC.  Therefore,
initial_boot_params will be NULL on OLPC.

> However, this _could_ change the behavior of OLPC and they could lack an
> RTC now if it is not comming via isa_pnp thing or via the device tree
> (which had no bindings until recently).

Yes, you'll need to coordinate with Andres to make sure everything
still works.  In fact, I'll be happiest if OLPC and embedded-x86 are
using the same RTC bindings.  However, that point might be moot since
Andres has told me that he has no intention of actually registering
devices from the tree, but rather to just export it to userspace.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
