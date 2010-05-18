Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0ERVDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:03:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48424 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0ERVDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:03:19 -0400
MIME-Version: 1.0
Message-ID: <0b1351a7-e9bc-4c28-87dc-2a70fc64bbca@default>
Date: Tue, 18 May 2010 14:02:41 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com>>
 <87tyq9mqrz.fsf@basil.nowhere.org>>
 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>>
 <20100515121424.38f5b389@infradead.org>>
 <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>>
 <20100515224305.17a04022@infradead.org>>
 <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>>
 <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>>
 <20100516220638.2baf315d@infradead.org> <1274176698.5605.7358.camel@twins>>
 <20100518112509.GD22675@basil.fritz.box> <1274183935.5605.7726.camel@twins>>
 <4BF2C30F.6030502@zytor.com> <1274201536.5605.8347.camel@twins>
 <4BF2C881.60807@zytor.com> <1dc4abc2-6455-4b95-90f6-c86bf56ff39a@default>
 <4BF2E0A2.6030209@zytor.com> <dd1c0508-5570-4e65-89c0-4037eb210646@default>
 <3479976f-5c91-4bcb-8542-3de93bee268a@default> <4BF2E9DB.3000202@zytor.com>
 <61e3a205-b578-4972-a65a-b96f779aeeb1@default 4BF2F9E4.8020808@zytor.com>
In-Reply-To: <4BF2F9E4.8020808@zytor.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4BF30081.002A:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm still not sure if you are in favor of optionally emulating
> > PL3 rdtsc instructions or not?  I thought my proposal was
> > just filling out some details of your proposal and suggesting
> > a default.
> 
> I'm not in favor of emulating rdtsc instructions.  I would consider
> letting them SIGILL (actually SIGSEGV since RDTSC #GP in userspace)
> 
> It's not clear to me that it's possible, though, since that also
> affects RDTSCP.

(All the variations are boggling so hard to discuss in
a linear email thread.)

IIUC, tglx/arjan consider RDTSC and RDTSCP to be in the same
category.  RDTSCP simply eliminates one large class of TSC
problems, but not all the possible system TSC problems that
the kernel can (or can't) detect.  So userspace (non-vsyscall)
shouldn't use either one

Further, this one redeeming feature of RDTSCP can be useless
and/or misleading in a virtual machine the way the kernel
sets up TSC_AUX.

> when the TSC is unavailable, though.

Do you mean "when the processor doesn't support a TSC instruction"
(very rare nowadays AFAIK) or "when the kernel determines that
TSC is not safe to use as a clocksource"?
