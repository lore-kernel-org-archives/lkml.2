Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab2CLNbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:31:38 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51798 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2CLNbg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 12 Mar 2012 09:31:36 -0400
Message-Id: <4F5E08C30200007800077ACC@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 12 Mar 2012 13:31:31 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: recent x86-64 nested NMI adjustments
References: <4F5DF5C30200007800077A5B@nat28.tlf.novell.com>
 <1331558201.25686.629.camel@gandalf.stny.rr.com>
In-Reply-To: <1331558201.25686.629.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 12.03.12 at 14:16, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-03-12 at 12:10 +0000, Jan Beulich wrote:
>> Hi Steven,
>> 
>> the explanation of 45d5a1683c04be28abdf5c04c27b1417e0374486
>> seems bogus to me: When arriving from user mode, %rsp won't point
>> to the user stack anymore, as it gets switched away from during the
>> processing of the exception (the more that the IDT entry specifies a
>> separate stack anyway, which even guarantees this for kernel mode
>> entries).
> 
> No it is real, and I had a test program that exploited it. I'm not
> worried about the current %rsp, I'm worried about what %rsp is saved on
> the stack. Two things are used to check if the incoming NMI is nested or
> not.
> 
> 1) if the on-stack "in-nmi" variable is set
> 
> 2) if the saved %rsp is pointing to the NMI stack.

Ah, right - the way the new check got placed I (wrongly) implied
it to guard the immediately succeeding check of the "special
variable", whereas it really guards (only) test_in_nmi.

Thanks for the explanation, and sorry for the noise then.

Jan

