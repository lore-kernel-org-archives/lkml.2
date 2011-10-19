Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab1JSXno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:43:44 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:55252
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab1JSXnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:43:42 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK9371K936eK1432N98dKzz1202hzzz2fh668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E9F6099.20904@am.sony.com>
Date: Wed, 19 Oct 2011 16:43:21 -0700
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
References: <4E9E0B71.9020708@am.sony.com>	 <1318983248.7569.5.camel@Joe-Laptop> <4E9E1944.80601@am.sony.com> <1318984301.7569.9.camel@Joe-Laptop>
In-Reply-To: <1318984301.7569.9.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 05:31 PM, Joe Perches wrote:
> On Tue, 2011-10-18 at 17:26 -0700, Tim Bird wrote:
>> On 10/18/2011 05:14 PM, Joe Perches wrote:
>>> On Tue, 2011-10-18 at 16:27 -0700, Tim Bird wrote:
>>>> I'm about to submit a set of patches (really pretty small)
>>>> to add 4K stack support to ARM (defaulted to 'N').
>>> When 4k stacks went away, I thought it safe enough
>>> to submit vsnprintf recursion using %pV.
>> Even inside Sony, usage of 4K stacks is limited
>> to some very special cases, where memory is exceedingly
>> tight (we have one system with 4M of RAM).  And we
>> don't mind lopping off features or coding around
>> problem areas to support our special case.
> 
> I believe CONFIG_PRINTK=n assures no %pV problem.

Indeed. Hehe. :-)  We might already be doing that in
the places we're using this.

Actually, this recursion is interesting.
My stack_size tool to detects stack usage for one instance
of a function.  But it would be easy to add a special
case to do a multiplier for functions known to potentially
recurse.  I'll have to look at that and maybe add something.

Relatedly, it might be interesting to augment the static
analysis with runtime information from the stack tracer.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

