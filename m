Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2BVIFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:05:41 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:52598 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2BVIFk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Wed, 22 Feb 2012 03:05:40 -0500
Message-Id: <4F44A1CF020000780007F637@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 22 Feb 2012 08:05:35 +0000
From: "Jan Beulich" <jbeulich@suse.com>
To: <mjw@redhat.com>
Cc: <fweisbec@gmail.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <ak@linux.intel.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: Fix CFI data for common_interrupt
References: <1329833177-13030-1-git-send-email-mjw@redhat.com>
 <4F43B78D020000780007435B@nat28.tlf.novell.com>
 <1329835436.12079.10.camel@springer.wildebeest.org>
 <4F43C5B60200007800074392@nat28.tlf.novell.com>
 <20120221220810.GE2590@toonder.wildebeest.org>
In-Reply-To: <20120221220810.GE2590@toonder.wildebeest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Mark Wielaard <mjw@redhat.com> 02/21/12 11:08 PM >>>
>On Tue, Feb 21, 2012 at 03:26:30PM +0000, Jan Beulich wrote:
>> >>> On 21.02.12 at 15:43, Mark Wielaard <mjw@redhat.com> wrote:
>> > For DW_CFA_def_register DWARF4 explicitly says so: "This operation is
>> > valid only if the current CFA rule is defined to use a register and
>> > offset." So one needs to use CFI_DEF_CFA with both a register and an
>> > offset here after the def_cfa_expression.
>> 
>> Hmm, that's in contrast to the gas implementation (but I'd certainly
>> give the specification preference if it explicitly states so, so gas
>> should at least emit a warning here rather than considering this
>> valid).
>
>I am afraid gas cannot help us here. Since like you pointed out in your
>patch:
>
>This requires the use of .cfi_escape (allowing arbitrary byte
>streams to be emitted into .eh_frame), as there is no
>.cfi_def_cfa_expression (which also cannot reasonably be
>expected, as it would require a full expression parser).
>
>So we are on our own here.

Hmm, yes, probably it wouldn't be nice if gas reset all its state when
.cfi_escape is used.

>> But provided the specification mandates this, I'm okay with the change
>> in principle. Just that specifying an offset of 0 doesn't look right then.
>
>Yeah, I dunno what I was thinking. The offset should be set to the offset
>that was there before when rsi was pushed. The attached patch does that
>by using the same value as was used at the start of common_interrupt.
>Does that look OK?

I would have thought that it should be SS+8-RBP (as %rbp is at the top
of the stack at that point). I can't verify this immediately, though, as I'm
not in the office today.

Jan

