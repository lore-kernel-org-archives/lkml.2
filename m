Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2LJLEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:04:12 -0500
Received: from smarthost01.mail.zen.net.uk ([212.23.1.1]:54452 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925Ab2LJLEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:04:10 -0500
Message-ID: <1355137445.3386.7.camel@linaro1.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 10 Dec 2012 11:04:05 +0000
In-Reply-To: <20121207190244.GB29618@mudshark.cambridge.arm.com>
References: <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
	 <20121207181309.GY14363@n2100.arm.linux.org.uk>
	 <1354905805.17101.86.camel@gandalf.local.home>
	 <20121207190244.GB29618@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 19:02 +0000, Will Deacon wrote:
> For ARMv7, there are small subsets of instructions for ARM and Thumb which
> are guaranteed to be atomic wrt concurrent modification and execution of
> the instruction stream between different processors:
> 
> Thumb:	The 16-bit encodings of the B, NOP, BKPT, and SVC instructions.
> ARM:	The B, BL, NOP, BKPT, SVC, HVC, and SMC instructions.
> 

So this means for things like kprobes which can modify arbitrary kernel
code we are going to need to continue to always use some form of
stop_the_whole_system() function?

Also, kprobes currently uses patch_text() which only uses stop_machine
for Thumb2 instructions which straddle a word boundary, so this needs
changing?

-- 
Tixy

