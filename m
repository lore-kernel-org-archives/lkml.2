Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab1GXWQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 18:16:07 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:49515 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab1GXWQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 18:16:05 -0400
Date: Mon, 25 Jul 2011 00:16:19 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
Message-ID: <20110724221619.GM16487@ics.muni.cz>
References: <20110720082640.GZ7561@ics.muni.cz>
 <4E280964.6070000@ct.jp.nec.com>
 <20110721132627.GY7561@ics.muni.cz>
 <4E291F28.2040609@ct.jp.nec.com>
 <20110722081903.GB7561@ics.muni.cz>
 <4E2A7806.1060601@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E2A7806.1060601@ce.jp.nec.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 94.112.253.31
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 25 Jul 2011 00:15:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 04:28:06PM +0900, Jun'ichi Nomura wrote:
> How fast is the single disk performance?

about 120MB/s if I run dd on a single disk only. 

> Could you check /proc/interrupts and /proc/softirqs and
> see how they are distributed among CPUs?

I don't see anything strange except function call interrupts hit single CPU
(that ksoftirqd). 

> As for the memory usage, what happens if you add 'iflag=direct' to dd?

then ksoftirqd does not eat significant amount of CPU.


> Also, is it possible for you to try the attached patch?
> I would like to know whether it changes the phenomenon you see.
> This patch should reduce the number of calls to recalc segments.
> If it is the root cause, the patch should fix your case.
> The patch is generated for 3.0 but should be easily applicable to
> other version of request-based dm.

the patch fixed the problem. I didn't test whether it broke something else or
not, though.

> As Kiyoshi suggested, it is important to know whether this
> problem occurs with the latest kernel.
> So if you could try 3.0, it would be very helpful.

so, do I need to check recent kernel as the patch works for me?

-- 
Luká¹ Hejtmánek
