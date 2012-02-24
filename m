Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2BXJty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:49:54 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:15949 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2BXJtx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Fri, 24 Feb 2012 04:49:53 -0500
Message-Id: <4F476B4E0200007800074936@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Feb 2012 09:49:50 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Mark Wielaard" <mjw@redhat.com>
Cc: "Frederic Weisbecker (commit_signer:4/25=16%)" <fweisbec@gmail.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "Thomas Gleixner(maintainer:X86 ARCHITECTURE...)" 
	<tglx@linutronix.de>,
        "Andi Kleen(commit_signer:5/25=20%)" <ak@linux.intel.com>,
        "commit_signer:11/25=44%)Ingo Molnar (maintainer:X86 ARCHITECTURE..." 
	<mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        "commit_signer:4/25=16%) H. Peter Anvin(maintainer:X86 ARCHITECTURE..." 
	<hpa@zytor.com>
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

>>> On 21.02.12 at 23:08, Mark Wielaard <mjw@redhat.com> wrote:
> On Tue, Feb 21, 2012 at 03:26:30PM +0000, Jan Beulich wrote:
>> But provided the specification mandates this, I'm okay with the change
>> in principle. Just that specifying an offset of 0 doesn't look right then.
> 
> Yeah, I dunno what I was thinking. The offset should be set to the offset
> that was there before when rsi was pushed. The attached patch does that
> by using the same value as was used at the start of common_interrupt.
> Does that look OK?

As written before, it ought to be

	CFI_DEF_CFA		rsi,SS+8-RBP /* reg/off reset after def_cfa_expr */

With that, feel free to add

Acked-by: Jan Beulich <jbeulich@suse.com>

when you re-submit.

Jan

