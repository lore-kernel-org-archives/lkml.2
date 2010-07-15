Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584Ab0GOThS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:37:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36751 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934546Ab0GOThP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:37:15 -0400
Message-ID: <4C3F6353.3090409@zytor.com>
Date: Thu, 15 Jul 2010 12:36:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zamsden@redhat.com>, Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix ordering constraints on crX read/writes
References: <4C3E363B.7060804@goop.org> <4C3E5637.4010300@redhat.com> <4C3E5C8C.8000800@goop.org> <b6d9e574-daf5-4aaa-b76e-4a7e66d0fa97@email.android.com> <4C3F1C84.8080503@goop.org> <4C3F5972.2030600@zytor.com> <4C3F6153.6020005@goop.org>
In-Reply-To: <4C3F6153.6020005@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 12:28 PM, Jeremy Fitzhardinge wrote:
> On 07/15/2010 11:54 AM, H. Peter Anvin wrote:
>> No, we haven't.  You're misunderstanding what a "memory" clobber does.
>> A clobber affects the output side only, but doesn't inherently provide
>> ordering on the input side.  Apparently this is implicit in "asm
>> volatile", which is a very important property.
> 
> OK. It would be nice to get that confirmed.
> 

The section in the docs (gcc 4.4.4 section 5.37) reads as:

If your assembler instructions access memory in an unpredictable
fashion, add `memory' to the list of clobbered registers.  This will
cause GCC to not keep memory values cached in registers across the
assembler instruction and not optimize stores or loads to that memory.
You will also want to add the `volatile' keyword if the memory affected
is not listed in the inputs or outputs of the `asm', as the `memory'
clobber does not count as a side-effect of the `asm'.  If you know how
large the accessed memory is, you can add it as input or output but if
this is not known, you should add `memory'.

This was clearer to me when I read it last evening, either because I was
tired and on an airplane ;) or because I read too much into it... it's
worth noting that an asm() in gcc is really nothing more than an
internal compiler event exposed to the user; the terms "output", "input"
and "clobber" have pretty specific meaning in compiler theory, and they
at least appear to be used that way.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

