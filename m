Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0JYKX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 06:23:29 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:33844
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692Ab0JYKX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 06:23:27 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zzbb2cK1432N98dN148cMzz1202hzz8275bh8275dhz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-WSS-ID: 0LAUCRN-02-00I-02
X-M-MSG: 
Date: Mon, 25 Oct 2010 12:21:11 +0200
From: Robert Richter <robert.richter@amd.com>
To: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:perf/urgent] x86/oprofile: Fix uninitialized variable use
 in debug printk
Message-ID: <20101025102110.GJ5969@erda.amd.com>
References: <20101025115736.41d51abe.sfr@canb.auug.org.au>
 <tip-2c78ffeca98fcd5a1dfd4a322438944506ed5e64@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-2c78ffeca98fcd5a1dfd4a322438944506ed5e64@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.10.10 02:52:03, tip-bot for Ingo Molnar wrote:
> Commit-ID:  2c78ffeca98fcd5a1dfd4a322438944506ed5e64
> Gitweb:     http://git.kernel.org/tip/2c78ffeca98fcd5a1dfd4a322438944506ed5e64
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Mon, 25 Oct 2010 08:41:09 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 25 Oct 2010 08:46:20 +0200
> 
> x86/oprofile: Fix uninitialized variable use in debug printk
> 
> Stephen Rothwell reported this build warning:
> 
>   arch/x86/oprofile/op_model_amd.c: In function 'ibs_eilvt_valid':
>   arch/x86/oprofile/op_model_amd.c:289: warning: 'offset' may be used uninitialized in this function
> 
> And correctly observed that indeed the variable is used uninitialized in
> this function. The result of this bug can be a debug printk with a bogus
> value.
> 
> Also fix a few more small details that made this function hard to read
> and which probably contributed to the bug being introduced to begin with:
> 
>  - Use more symmetric error conditions
> 
>  - Remove the !0 obfuscation
> 
>  - Add newlines to the printk output
> 
>  - Remove bogus linebreaks in printk strings and elsewhere

Ingo, thanks for changing this, it all looks good to me, though we
actually don't have to print the offset as the valid bit is not set.

For some reason I didn't catch the warning:

...
  LD      arch/x86/kernel/acpi/built-in.o
  CC      arch/x86/oprofile/op_model_amd.o
  CC      arch/x86/kernel/cpu/intel_cacheinfo.o
...

(using gcc (Gentoo 4.4.3-r2 p1.2) 4.4.3)

... but it should warn.

-Robert

> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> LKML-Reference: <20101025115736.41d51abe.sfr@canb.auug.org.au>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

