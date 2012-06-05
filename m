Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2FEP6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:58:50 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:51839
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab2FEP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:58:49 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839hd25he5bhf0ah)
Message-ID: <4FCE2CB1.5090308@freescale.com>
Date: Tue, 5 Jun 2012 10:58:41 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 5/5] powerpc/85xx: add support to JOG feature using
 cpufreq interface
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com> <1336737235-15370-5-git-send-email-chenhui.zhao@freescale.com> <4FC950AF.90007@freescale.com> <20120605105929.GA22427@localhost.localdomain>
In-Reply-To: <20120605105929.GA22427@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 05:59 AM, Zhao Chenhui wrote:
> On Fri, Jun 01, 2012 at 06:30:55PM -0500, Scott Wood wrote:
>> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
>>> The jog mode frequency transition process on the MPC8536 is similar to
>>> the deep sleep process. The driver need save the CPU state and restore
>>> it after CPU warm reset.
>>>
>>> Note:
>>>  * The I/O peripherals such as PCIe and eTSEC may lose packets during
>>>    the jog mode frequency transition.
>>
>> That might be acceptable for eTSEC, but it is not acceptable to lose
>> anything on PCIe.  Especially not if you're going to make this "default y".
> 
> It is a hardware limitation.

Then make sure jog isn't used if PCIe is used.

Maybe you could do something with the suspend infrastructure, but this
is sufficiently heavyweight that transitions should be manually
requested, not triggered by the automatic cpufreq governor.

Does this apply to p1022, or just mpc8536?

> Peripherals in the platform will not be operating
> during the jog mode frequency transition process.

What ensures this?

-Scott

