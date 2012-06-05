Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2FEQQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:16:08 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:2719
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab2FEQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:16:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FCE30B8.2070902@freescale.com>
Date: Tue, 5 Jun 2012 11:15:52 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 2/5] powerpc/85xx: add HOTPLUG_CPU support
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com> <1336737235-15370-2-git-send-email-chenhui.zhao@freescale.com> <4FC933BF.1020901@freescale.com> <20120604110444.GA20676@localhost.localdomain> <4FCCE32F.1060301@freescale.com> <20120605111823.GB22427@localhost.localdomain>
In-Reply-To: <20120605111823.GB22427@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 06:18 AM, Zhao Chenhui wrote:
> On Mon, Jun 04, 2012 at 11:32:47AM -0500, Scott Wood wrote:
>> On 06/04/2012 06:04 AM, Zhao Chenhui wrote:
>>> On Fri, Jun 01, 2012 at 04:27:27PM -0500, Scott Wood wrote:
>>>> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
>>>>> -#ifdef CONFIG_KEXEC
>>>>> +#if defined(CONFIG_KEXEC) || defined(CONFIG_HOTPLUG_CPU)
>>>>
>>>> Let's not grow lists like this.  Is there any harm in building it
>>>> unconditionally?
>>>>
>>>> -Scott
>>>
>>> We need this ifdef. We only set give_timebase/take_timebase
>>> when CONFIG_KEXEC or CONFIG_HOTPLUG_CPU is defined.
>>
>> If we really need this to be a compile-time decision, make a new symbol
>> for it, but I really think this should be decided at runtime.  Just
>> because we have kexec or hotplug support enabled doesn't mean that's
>> actually what we're doing at the moment.
>>
>> -Scott
> 
> If user does not enable kexec or hotplug, these codes are redundant.
> So use CONFIG_KEXEC and CONFIG_HOTPLUG_CPU to gard them.

My point is that these lists tend to grow and be a maintenance pain.
For small things it's often better to not worry about saving a few
bytes.  For larger things that need to be conditional, define a new
symbol rather than growing ORed lists like this.

-Scott

