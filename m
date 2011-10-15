Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1JOAW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:22:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33249 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1JOAWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:22:25 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=jVLHYovT1_cA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=tHz9FfFoAAAA:8 a=6onK2RP5Y43qiiEBcqsA:9 a=PUjeQqilurYA:10 a=6O0IECtVFhoA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318638140.12224.81.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RFC V4 09/10] x86/jump_label: use GENERIC_NOP5_ATOMIC
 instead of jmp5 +0
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Fri, 14 Oct 2011 20:22:20 -0400
In-Reply-To: <4E98AF71.40303@zytor.com>
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com>
	  <34ede5db1571d541a5c3fc49923bb353a37dd431.1318464413.git.jeremy.fitzhardinge@citrix.com>
	  <4E97067A.2070305@zytor.com> <4E97188A.6040400@goop.org>
	 <1318531022.12224.13.camel@gandalf.stny.rr.com> <4E98AF71.40303@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 14:53 -0700, H. Peter Anvin wrote:
> On 10/13/2011 11:37 AM, Steven Rostedt wrote:
> > On Thu, 2011-10-13 at 09:57 -0700, Jeremy Fitzhardinge wrote:
> >> On 10/13/2011 08:40 AM, H. Peter Anvin wrote:
> >>> On 10/12/2011 05:08 PM, Jeremy Fitzhardinge wrote:
> >>>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >>>>
> >>>> GENERIC_NOP5_ATOMIC should make a better nop.
> >>>>
> >>> On 32 bits, yes.  On 64 bits you should use P6_NOP5_ATOMIC.
> >>
> >> Something like this?
> >>
> > 
> > No, we only care about 5byte nops here. Look at ideal_nop in
> > alterative.c
> > 
> 
> He needs a compile-time alternative.

I didn't explain this well. I actually just meant something like:

#ifdef CONFIG_X86_64
# define IDEAL_NOP5	P6_NOP5_ATOMIC
#else
# define IDEAL_NOP5	GENERIC_NOP5_ATOMIC
#endif

That is, we know we are using this for a 5byte jump. Just keep it simple
for that. Do you envision needing other nops too? Well, we could do 2
byte nops, but I think we could use the same for both. Can't we?

-- Steve


