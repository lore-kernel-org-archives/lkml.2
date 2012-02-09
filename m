Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab2BIN2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:28:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48415 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab2BIN2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:28:52 -0500
Date: Thu, 9 Feb 2012 14:28:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>, jk@novozymes.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Memory issues with Opteron 6220
Message-ID: <20120209132825.GB8830@elte.hu>
References: <20120208143741.GB28486@otto.nzcorp.net>
 <20120208205628.GA18909@alberich.amd.com>
 <20120209124355.GA20902@otto.nzcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209124355.GA20902@otto.nzcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anders Ossowicki <aowi@novozymes.com> wrote:

> I went digging through the power management options of the 
> bios and found that CPU performance was set to System DBPM[1] 
> by default. After switching it to OS DBPM, powernow-k8 seemed 
> a lot happier:

Your bootlog says:

[    0.330000] Performance Events: Broken BIOS detected, complain to your hardware vendor.
[    0.330000] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 1430076)

Do you get that message if DBPM is enabled?

If the message disappeared then I'd suggest to do what that 
kernel message suggests and ask the vendor to disable that BIOS 
option by default, it breaks stuff.

Thanks,

	Ingo
