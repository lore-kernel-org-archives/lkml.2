Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0ERRHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:07:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46306 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757854Ab0ERRHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:07:39 -0400
Message-ID: <4BF2C881.60807@zytor.com>
Date: Tue, 18 May 2010 10:04:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com>	 <87tyq9mqrz.fsf@basil.nowhere.org>	 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>	 <20100515121424.38f5b389@infradead.org>	 <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>	 <20100515224305.17a04022@infradead.org>	 <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>	 <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>	 <20100516220638.2baf315d@infradead.org> <1274176698.5605.7358.camel@twins>	 <20100518112509.GD22675@basil.fritz.box> <1274183935.5605.7726.camel@twins>	  <4BF2C30F.6030502@zytor.com> <1274201536.5605.8347.camel@twins>
In-Reply-To: <1274201536.5605.8347.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2010 09:52 AM, Peter Zijlstra wrote:
> On Tue, 2010-05-18 at 09:40 -0700, H. Peter Anvin wrote:
>>
>> The problem is that you throw the baby (vsyscall) out with the bathwater
>> (user rdtsc). 
> 
> Well, we could only flip the CR4 bit when we mark the TSC unsuitable for
> gtod. That should be plenty good to tag all userspace trying to use it,
> since more than half my machines don't use TSC for clocksource.

This might be an option, although it would have to be an *option*.
There are restricted uses of the TSC in userspace which are still useful
(mainly involving performance analysis and/or CPU-locked processes).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

