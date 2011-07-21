Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1GUHRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:17:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53393 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab1GUHRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:17:23 -0400
Date: Thu, 21 Jul 2011 09:16:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: make enabling of MMCFG on AMD Fam10 CPUs
 actually work
Message-ID: <20110721071638.GD9216@elte.hu>
References: <4E258A11020000780004E39B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E258A11020000780004E39B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> Forcibly enabling the MMCFG space on AMD Fam10 CPUs cannot be expected
> to work, since with the firmware not being aware of the address range
> used, it cannot possibly reserve the space in E820 or ACPI resources.
> Hence we need to manually insert the range into the E820 table, and
> enable the range only when the insertion actually works without
> conflict.
> 
> Adding the calls to the respective E820 handling functions additionally
> requires to deal with modpost's mismatch checking: The function doing
> those calls needs to be __init, and it is being made sure that it gets
> called (from its __cpuinit caller) only on the BSP, and through a stub
> (silencing the warning).
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/mmconf-fam10h_64.c |   22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)

I agree with the patch (and please also add the second fix you 
extracted from Yinghai's patch, as a second patch).

This changelog is missing scope analysis: what systems are affected 
in practice (if any), were actual problems observed, if no problems 
were observed then what are the potential problems that people should 
look out for (and which this commit may fix), etc.

If none of that information is available then such a small blurb:

 'This bug was found via code review and I'm not aware of any systems
  that are affected currently - but some may exist.'

Will inform maintainers and other interested parties about the 
practical background of the patch.

Thanks,

	Ingo
