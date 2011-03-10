Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1CJWYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:24:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37272 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1CJWYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:24:05 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=UwRGqXM3h7MA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1oKFPfMvbG41-orYmXYA:9 a=_FBhTDIMlCVNrypBLtBg9NoJ_dcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: update for .39
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Jason Baron <jbaron@redhat.com>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <4D794C7C.5010008@caviumnetworks.com>
References: <1299771504.15854.347.camel@gandalf.stny.rr.com>
	 <4D790A13.4060705@caviumnetworks.com>
	 <1299780241.15854.393.camel@gandalf.stny.rr.com>
	 <20110310182000.GB2906@redhat.com>
	 <1299782143.15854.402.camel@gandalf.stny.rr.com>
	 <4D791CAA.7090108@caviumnetworks.com>
	 <1299783236.15854.405.camel@gandalf.stny.rr.com>
	 <4D791F31.6040100@caviumnetworks.com>
	 <1299785143.15854.407.camel@gandalf.stny.rr.com>
	 <1299786329.15854.409.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP311155BEBE5F141636A6E596C80@phx.gbl>
	 <1299793339.15854.430.camel@gandalf.stny.rr.com>
	 <4D794C7C.5010008@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 17:24:01 -0500
Message-ID: <1299795841.15854.433.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 14:11 -0800, David Daney wrote:

> But that shouldn't matter because we only emit data to the __jump_table 
> section from asm().
> 
> GCC is getting a reference to that table (array of structures really) 
> from a global variable, I don't see how it can violate the ABI in this case.

Right, actually gcc should be completely out of the loop, as it has no
idea about that section we created. That's done in the assembly phase,
and the linker should not be adding holes.

-- Steve


