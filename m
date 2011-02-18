Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1BRIG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:06:56 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:41235 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1BRIGw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 18 Feb 2011 03:06:52 -0500
Message-Id: <4D5E36DD02000078000329CE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Feb 2011 08:07:41 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tony.luck@intel.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 2/3] x86-64: use relative 32-bit pointers in
	 exception tables
References: <4D5D62EE02000078000327E7@vpn.id2.novell.com>
 <20110217172559.GD17058@elte.hu>
In-Reply-To: <20110217172559.GD17058@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.02.11 at 18:25, Ingo Molnar <mingo@elte.hu> wrote:

> Nice patch. I've got a really small code readability nitpick:
> 
>> +#ifndef ex_insn /* until all architectures have this accessor */
>> +#define ex_insn(x) (x)->insn
>> +#endif
> 
>> +#else
>> +#define swap_ex NULL
>> +#endif
> 
> In the x86 architecture we tend to write this as:
> 
>> +#else
>> +# define swap_ex NULL
>> +#endif
> 
> So that the conditional structure stands out more, visually. (There might be 
> more 
> such cases in these patches as well.)

I can certainly fix this, but got a comment from (I think) Andrew
Morton to do exactly the opposite quite some time ago, with the
rationale that this indentation leads to more involved patches
when further conditionals get added around them.

As I'll have to fix the test_nx issue hpa pointed out anyway, I can
adjust this as you say, but I'd prefer you to confirm first whether
indeed you think this is the right thing to do in non-x86 code.

Jan

