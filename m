Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0ERQwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:52:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:36644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0ERQwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:52:45 -0400
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <4BF2C30F.6030502@zytor.com>
References: <1273887635-27610-1-git-send-email-venki@google.com>
	 <87tyq9mqrz.fsf@basil.nowhere.org>
	 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
	 <20100515121424.38f5b389@infradead.org>
	 <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
	 <20100515224305.17a04022@infradead.org>
	 <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>
	 <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>
	 <20100516220638.2baf315d@infradead.org> <1274176698.5605.7358.camel@twins>
	 <20100518112509.GD22675@basil.fritz.box> <1274183935.5605.7726.camel@twins>
	  <4BF2C30F.6030502@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 May 2010 18:52:16 +0200
Message-ID: <1274201536.5605.8347.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 09:40 -0700, H. Peter Anvin wrote:
> 
> The problem is that you throw the baby (vsyscall) out with the bathwater
> (user rdtsc). 

Well, we could only flip the CR4 bit when we mark the TSC unsuitable for
gtod. That should be plenty good to tag all userspace trying to use it,
since more than half my machines don't use TSC for clocksource.
