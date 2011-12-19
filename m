Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1LSORO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 09:17:14 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:12979
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810Ab1LSORM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 09:17:12 -0500
X-SpamScore: -19
X-BigFish: VPS-19(zz179dN1432N98dK4015Lzz1202hzzz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWGFOH-02-02I-02
X-M-MSG: 
Date: Mon, 19 Dec 2011 15:17:03 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for 3.2
Message-ID: <20111219141703.GG16765@erda.amd.com>
References: <1324302373-30872-1-git-send-email-robert.richter@amd.com>
 <20111219140049.GA9097@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111219140049.GA9097@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.12.11 15:00:49, Ingo Molnar wrote:

> +	if (!count)
> +		return 0;
> +
>  	retval = oprofilefs_ulong_from_user(&value, buf, count);
>  	if (retval)
>  		return retval;
> 
> See the ugly and fragile pattern?
> 
> This should *really* be solved via the 
> oprofilefs_ulong_from_user() helper function, not by sprinkling 
> the !count checks in half a dozen places ...

Hmm, I thought there was no way to leave the code path with count == 0
and retval. But thinking about it it would be possible with returning
count or errors < 0. Will improve the patch.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

