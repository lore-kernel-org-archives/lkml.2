Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab1GELQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:16:22 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44531 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab1GELQU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Tue, 5 Jul 2011 07:16:20 -0400
Message-Id: <4E130EA0020000780004C24A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 05 Jul 2011 12:16:16 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86/EFI: properly pre-initialize table pointers
References: <4E12DC26020000780004C1C1@nat28.tlf.novell.com>
 <20110705093343.GB5725@elte.hu>
In-Reply-To: <20110705093343.GB5725@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.07.11 at 11:33, Ingo Molnar <mingo@elte.hu> wrote:

> * Jan Beulich <JBeulich@novell.com> wrote:
> 
>> Consumers of the table pointers in struct efi check for
>> EFI_INVALID_TABLE_ADDR to determine validity, hence these pointers
>> should all be pre-initialized to this value (rather than zero).
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> 
>> ---
>>  arch/x86/platform/efi/efi.c |   12 +++++++++++-
>>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> This changelog is missing some key information:
> 
>  - how did you find the bug (by chance via code review or did you see
>    some actual badness?)

I can certainly add that information and re-send, but would certainly
have stated any really bad effect if I had observed such.

>  - what practical effect (if any) did you see from this patch?
> 
>  - what practical effect (if any) do you expect others to see from this 
> patch?

Hmm, I can't really see why this kind of information (especially the
last) would belong into a changeset comment, the more a pretty
obvious one like this.

> This kind of information helps us prioritize bugfixes.

Bug fixes are bug fixes - unless they fix really critical issues (and
here that's unlikely to be the case, as the code had been wrong
for ages), I don't follow why you require more information to be
added than a description of what gets changed (the "why" should
really only matter if it's debatable whether the original code was
wrong).

Furthermore, this being not the first time you ask (from my pov)
to be overly verbose when it comes to describing changes and
their effects - is it unreasonable to expect you (not always you
personally, but you as being one of the three x86 maintainers;
you hopefully agree that from my position it doesn't really
matter who answers as long as someone assumes that
responsibility) to be a little less lax in responding to submitted
patches? I would roughly estimate that 50% of the patches I
send get dropped on the floor with no response whatsoever
(there are even cases where you welcomed patches, but never
applied them or responded with a revised opinion on a re-
submission). I clearly realize that the volume you need to deal
with must be pretty high, yet I don't think that ought to be an
excuse for other than occasional cases of this happening.

And yes, there are also other times when things get integrated
*very* quickly, and I definitely appreciate that.

Jan

> Thanks,
> 
>     Ingo



