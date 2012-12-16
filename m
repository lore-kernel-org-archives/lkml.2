Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab2LPTqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 14:46:11 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42539 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab2LPTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 14:46:10 -0500
X-Sasl-enc: dTqnFVLMg2fiq+V/hqX4PD7FZBHIF4jaybzqpwJAvIkd 1355687168
Message-ID: <50CE24FE.3030409@itwm.fraunhofer.de>
Date: Sun, 16 Dec 2012 20:46:06 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Weidong Han <weidong.han@intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [regression] 3.7 ends in APIC panic
References: <50CB3EAB.309@itwm.fraunhofer.de> <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com> <CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com> <50CE0C82.20708@itwm.fraunhofer.de> <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com> <50CE12EB.1050804@itwm.fraunhofer.de> <20121216191347.GB14678@liondog.tnic>
In-Reply-To: <20121216191347.GB14678@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2012 08:13 PM, Borislav Petkov wrote:
> On Sun, Dec 16, 2012 at 07:28:59PM +0100, Bernd Schubert wrote:
>> CONFIG_X86_X2APIC depends on CONFIG_IRQ_REMAP, which I disabled as it
>> is marked as experimental...
> 
> You shouldn't pay too much attention to CONFIG_EXPERIMENTAL because it
> is on its way out from the kernel tree.

I usually don't too much, if I understand what it is about and what are
the consequences.

> 
> But if you don't want to have interrupt remapping on your system,
> you can disable it nevertheless. Wait, you can't: according to
> d0b03bd1c6725a3463290d7f9626e4b583518a5a, you can use x2apic without
> interrupt remapping but interrupt remapping needs to be enabled before
> x2apic.

Hmm, I read it the other way around - x2apic depends on interrupt
remapping, but interrupt remapping can be used without x2apic.

The help text of CONFIG_IRQ_REMAP also says "x2APIC enhancements or to
support platforms with CPU's having > 8 bit APIC ID, say Y." I guess may
CPU has the latter? Can the kernel panic a bit improved to help user to
understand what needs to be enabled?


Thanks,
Bernd
