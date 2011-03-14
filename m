Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1CNKwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:52:15 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:42766 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1CNKwO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 14 Mar 2011 06:52:14 -0400
Message-Id: <4D7E0196020000780003638B@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 14 Mar 2011 10:52:54 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Alan Modra" <amodra@gmail.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <binutils@sourceware.org>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
References: <20110311165802.GA3508@intel.com>
 <4D7A64670200007800035F4C@vpn.id2.novell.com>
 <AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
 <4D7DE39302000078000362E6@vpn.id2.novell.com>
 <20110314095534.GB18058@elte.hu>
 <20110314104131.GG6275@bubble.grove.modra.org>
In-Reply-To: <20110314104131.GG6275@bubble.grove.modra.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.03.11 at 11:41, Alan Modra <amodra@gmail.com> wrote:
> On Mon, Mar 14, 2011 at 10:55:34AM +0100, Ingo Molnar wrote:
>> The thing is, it is absolutely, breath-takingy incompetent for
> 
> kernel developers to write such poor asm!  And not notice the error
> for 4 years!  Oh, and the binutils developers to write such a poor
> assembler in the first place.  ;-)
> 
> Seriously, you are complaining because something is fixed??
> 
>> The correct solution is to turn it into a warning as me and others have 
> suggested.
> 
> I disagree.  The whole world is not the linux kernel.  I think HJ is
> bending over backwards to even offer a switch that turns the error
> into a warning.

Just to repeat what I said in a previous reply - an error should be
issued if it is impossible for the assembler to produce valid output.
Anything less severe should be a warning.

In the case given, as also stated before, simply not issuing anything
to the object file if .size has an invalid operand is quite feasible for
the assembler to do, and won't produce invalid output. The warning
tells the programmer that not everything (s)he intended to be in
the object file actually made it there.

Jan

