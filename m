Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab0ERUig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:38:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41091 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab0ERUif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:38:35 -0400
Message-ID: <4BF2F9E4.8020808@zytor.com>
Date: Tue, 18 May 2010 13:34:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com>> <87tyq9mqrz.fsf@basil.nowhere.org>> <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>> <20100515121424.38f5b389@infradead.org>> <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>> <20100515224305.17a04022@infradead.org>> <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>> <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>> <20100516220638.2baf315d@infradead.org> <1274176698.5605.7358.camel@twins>> <20100518112509.GD22675@basil.fritz.box> <1274183935.5605.7726.camel@twins>> <4BF2C30F.6030502@zytor.com> <1274201536.5605.8347.camel@twins> <4BF2C881.60807@zytor.com> <1dc4abc2-6455-4b95-90f6-c86bf56ff39a@default> <4BF2E0A2.6030209@zytor.com> <dd1c0508-5570-4e65-89c0-4037eb210646@default> <3479976f-5c91-4bcb-8542-3de93bee268a@default 4BF2E9DB.3000202@zytor.com> <61e3a205-b578-4972-a65a-b96f779aeeb1@default>
In-Reply-To: <61e3a205-b578-4972-a65a-b96f779aeeb1@default>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 01:29 PM, Dan Magenheimer wrote:
> 
> Yes, understood, a minor semantic issue.  From a kernel perspective
> vsyscalls are kernelspace, so IIUC this is OK with tglx/etc.
> 
> Since vsyscall shouldn't be using rdtsc when the kernel
> doesn't trust TSC, it doesn't matter if CR4.TSD is enabled when
> the kernel doesn't trust TSC.
> 

That is correct.

> I'm still not sure if you are in favor of optionally emulating
> PL3 rdtsc instructions or not?  I thought my proposal was
> just filling out some details of your proposal and suggesting
> a default.

I'm not in favor of emulating rdtsc instructions.  I would consider
letting them SIGILL (actually SIGSEGV since RDTSC #GP in userspace) when
the TSC is unavailable, though.

It's not clear to me that it's possible, though, since that also affects
RDTSCP.

	-hpa


