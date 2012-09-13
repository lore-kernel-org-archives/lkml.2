Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab2IMSRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:17:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:56159 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2IMSRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:17:09 -0400
Subject: Re: [PATCH] powerpc/smp: Do not disable IPI interrupts during suspend
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1C2FF4B5-3F3C-4A9D-941D-A4BC4F5C95DE@kernel.crashing.org>
Date: Thu, 13 Sep 2012 13:16:51 -0500
Cc: "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        Zhao Chenhui <chenhui.zhao@freescale.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <287921FF-96B1-4BBC-B9F9-3F8D24244061@kernel.crashing.org>
References: <1342788421-27648-1-git-send-email-chenhui.zhao@freescale.com> <5028672F-1873-4E45-AA23-4CA9F191BE77@kernel.crashing.org> <1343427631.21647.1.camel@pasglop> <20120802100418.GA13777@localhost.localdomain> <1C2FF4B5-3F3C-4A9D-941D-A4BC4F5C95DE@kernel.crashing.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 10, 2012, at 7:40 AM, Kumar Gala wrote:

> 
> On Aug 2, 2012, at 5:04 AM, Zhao Chenhui wrote:
> 
>> On Sat, Jul 28, 2012 at 08:20:31AM +1000, Benjamin Herrenschmidt wrote:
>>> On Fri, 2012-07-27 at 16:58 -0500, Kumar Gala wrote:
>>>> On Jul 20, 2012, at 7:47 AM, Zhao Chenhui wrote:
>>>> 
>>>>> During suspend, all interrupts including IPI will be disabled. In this case,
>>>>> the suspend process will hang in SMP. To prevent this, pass the flag
>>>>> IRQF_NO_SUSPEND when requesting IPI irq.
>>>>> 
>>>>> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
>>>>> Signed-off-by: Li Yang <leoli@freescale.com>
>>>>> ---
>>>>> arch/powerpc/kernel/smp.c |    2 +-
>>>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>> 
>>>> BenH,
>>>> 
>>>> Can you ack?
>>> 
>>> No I'll merge it but not until it's been in next for a bit unless you
>>> have some strong emergency there, it's on my mental list of things to
>>> shovel into next after rc1.
>>> 
>>> Curiosity: didn't we use to disable all non-boot CPUs on suspend ?
>>> 
>>> Cheers,
>>> Ben.
>> 
>> Yes, we disabled all non-boot CPUs on suspend by calling disable_nonboot_cpus().
>> The disable_nonboot_cpus() needs IPIs to work. But prior to
>> calling disable_nonboot_cpus(), the IPIs are disabled in dpm_suspend_noirq().
>> 
>> -Chenhui
> 
> Benh, Ack?

Ben?

- k