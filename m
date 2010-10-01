Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0JAPqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 11:46:11 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:58519 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab0JAPqJ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Fri, 1 Oct 2010 11:46:09 -0400
Message-Id: <4CA61E8B020000780001A22A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 01 Oct 2010 16:46:51 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <heukelum@fastmail.fm>,
        <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org>
 <4C91F07E0200007800016B50@vpn.id2.novell.com>
 <20100916082816.GA25681@elte.hu>
 <4C91F3A30200007800016B64@vpn.id2.novell.com>
 <20100916101355.GA31458@elte.hu>
 <4C9219BC0200007800016C53@vpn.id2.novell.com> <4CA52AA5.5040402@zytor.com>
 <4CA5B7910200007800019F50@vpn.id2.novell.com> <4CA5FC96.1030300@zytor.com>
In-Reply-To: <4CA5FC96.1030300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 01.10.10 at 17:21, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 10/01/2010 01:27 AM, Jan Beulich wrote:
>>>>> On 01.10.10 at 02:26, "H. Peter Anvin" <hpa@zytor.com> wrote:
>>> ... but that doesn't work with the macros like movq_cfi.  On those, we
>> 
>> Is that only because of the register names used as operands to
>> movq_cfi etc not having the % specified right away? I don't think
>> that is really needed, i.e. the % could go there rather than being
>> added in the macro body - the .cfi_* directives are perfectly happy
>> with having the prefix there (and I don't know why it was coded
>> this way in the first place, as this made it less similar to the plain
>> movq while I thought the goal was to keep the differences to a
>> minimum).
>> 
> 
> No, and in fact the problem that spurred this discussion was in the use
> of immediates, not registers:
> 
> 	pushq_cfi $(USER_DS)
> 
> Obviously we can't add the % register prefix, since pushq can take
> either a register or an immediate (or, for that matter, a memory operand).

Perhaps a misunderstanding? I meant to move the % back into
movq_cfi's arguments, out of the macro body. pushq_cfi already
is in the shape we need for having the option of using cpp macros
when !CONFIG_AS_CFI.

>> The other alternative, albeit disliked by Ingo, continues to be to use
>> __stringify() on all non-trivial operands, which then wouldn't require
>> suppressing CONFIG_AS_CFI for pre-2.17 binutils.
> 
> You should be taken out and shot for even thinking that, never mind
> putting it in writing...

Thank you!

Jan

