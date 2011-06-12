Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab1FLHYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 03:24:47 -0400
Received: from in.cluded.net ([195.159.98.120]:32897 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1FLHYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 03:24:46 -0400
Message-ID: <4DF46971.6080200@uw.no>
Date: Sun, 12 Jun 2011 07:23:29 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: David Miller <davem@davemloft.net>, viro@ZenIV.linux.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Sparc: Remove trigraph in die_if_kernel() message.
References: <alpine.LNX.2.00.1106071627260.8844@swampdragon.chaosbits.net> <20110609.155943.162785602513776337.davem@davemloft.net> <20110609230322.GY11521@ZenIV.linux.org.uk> <20110609.160611.1243367560228886911.davem@davemloft.net> <alpine.LNX.2.00.1106100947010.19998@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1106100947010.19998@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> On Thu, 9 Jun 2011, David Miller wrote:
> 
>> From: Al Viro <viro@ZenIV.linux.org.uk>
>> Date: Fri, 10 Jun 2011 00:03:22 +0100
>>
>>> On Thu, Jun 09, 2011 at 03:59:43PM -0700, David Miller wrote:
>>>>> If I'm not mistaken, that "??!" will be taken as a trigraph for "|" by the 
>>>>> preprocessor, so the final string will end up either as
>>>>>   "Penguin instruction from Penguin mode|?!"
>>> Not without -trigraphs, which is not on by default...
>> Oh, in that case I'll rever this.
>>
> 
> Well, my gcc warns about it. It seems that -Wtrigraphs is enabled by 
> default:

Perhaps the _real_ fix is just to remove all the interrobanging going on here,
and be in line with all the other die_if_kernel() calls in the file.

Something like this?

(Yeah, I shamelessly snarfed the patch from Jesper, and deleted all the excess
?'s and !'s. I haven't cared enough figure out the proper *-by: attribution
magic to credit Jesper, so someone just add whatever is necessary if they feel
so inclined. I can't pretend to care much about my contribution in this.)

Signed-off-by: Daniel K. <dk@uw.no>
---
diff --git a/arch/sparc/kernel/traps_32.c b/arch/sparc/kernel/traps_32.c
index c0490c7..d99ca40 100644
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -137,7 +137,7 @@ void do_priv_instruction(struct pt_regs *regs, unsigned long pc, unsigned long n
 	siginfo_t info;
 
 	if(psr & PSR_PS)
-		die_if_kernel("Penguin instruction from Penguin mode??!?!", regs);
+		die_if_kernel("Penguin instruction from Penguin mode", regs);
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_PRVOPC;
