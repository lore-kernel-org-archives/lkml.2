Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab1JSA1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 20:27:09 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:57419
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751258Ab1JSA1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 20:27:07 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zzbb2dK9371K936eK1418M1432N98dK111aLzz1202hzzz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 0,
Message-ID: <4E9E1944.80601@am.sony.com>
Date: Tue, 18 Oct 2011 17:26:44 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Russell King <rmk@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
References: <4E9E0B71.9020708@am.sony.com> <1318983248.7569.5.camel@Joe-Laptop>
In-Reply-To: <1318983248.7569.5.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 05:14 PM, Joe Perches wrote:
> On Tue, 2011-10-18 at 16:27 -0700, Tim Bird wrote:
>> I'm about to submit a set of patches (really pretty small)
>> to add 4K stack support to ARM (defaulted to 'N').
> 
> When 4k stacks went away, I thought it safe enough
> to submit vsnprintf recursion using %pV.
> 
> I believe the current vsnprintf max recursion is 3.
> Each recursion uses at least 300 bytes of stack.
> 
> That might be some additional issue for 4k stacks.

Interesting.  Thanks very much for the heads up.
I don't know how prevalent %pV is, but I'll take a
look tomorrow and see if I think this would be an
issue.  One option would be to turn off recursion
in the 4K stacks case (but I don't know how badly
this would mangle the code).

I'm not sure I'm willing to advocate eliminating
all occurrences of high stack usage in the kernel.
It seems like this would generate a lot of friction
for getting this mainlined.  As long as I can document
the trouble that people might get in when they
turn this on, I think that would be very good.

Even inside Sony, usage of 4K stacks is limited
to some very special cases, where memory is exceedingly
tight (we have one system with 4M of RAM).  And we
don't mind lopping off features or coding around
problem areas to support our special case.

Thanks again for the notice.
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

