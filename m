Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab1CCOgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:36:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49585 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183Ab1CCOgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:36:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ety31qeetIp8ZN6nZKCsauigUTJ+ugf6W87Zn2yD923xlHbguqJ2yvVdQmxGVt+VLs
         V6NI83mqdc/5FSRj8XT5IWCX61SPTJhB/dCDiqaHyXalupanD1MO8pvDTwPp1QP1K0Te
         Bnhj/Ixbkz9R7WT+2qXcXn4P6nQY7F60MIjJc=
MIME-Version: 1.0
In-Reply-To: <20110303143051.GI13094@bubble.grove.modra.org>
References: <AANLkTimqT82wR20vvunnMvNShFSs0zWtmeT66A84Nh5t@mail.gmail.com>
	<AANLkTi=m_qO0=o81+Db_B-kt1DWP-Af6So+_LiZMgONF@mail.gmail.com>
	<20110303143051.GI13094@bubble.grove.modra.org>
Date: Thu, 3 Mar 2011 06:36:04 -0800
Message-ID: <AANLkTindraLdZzP=emga7EdzGnLbnhJ4DR=eQ2rSu9Yf@mail.gmail.com>
Subject: Re: [BUG] as of trunk build Linux kernel trunk entry_32.S got error
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Hui Zhu <teawater@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, binutils@sourceware.org
Cc: Alan Modra <amodra@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 6:30 AM, Alan Modra <amodra@gmail.com> wrote:
> On Thu, Mar 03, 2011 at 05:48:01AM -0800, H.J. Lu wrote:
>> On Wed, Mar 2, 2011 at 10:16 PM, Hui Zhu <teawater@gmail.com> wrote:
>> > as -version
>> > GNU assembler (GNU Binutils) 2.21.51.20110303
>> >  AS      arch/x86/kernel/entry_32.o
>> > /home/teawater/big/kernel/linux-2.6/arch/x86/kernel/entry_32.S:
>> > Assembler messages:
>> > /home/teawater/big/kernel/linux-2.6/arch/x86/kernel/entry_32.S:1422:
>> > Error: .size expression does not evaluate to a constant
>> >
>> > When I change back to the as of system, everything is OK.
>> >
>> > Because I always use the as of trunk, so I think a recent PATCH caused
>> > the problem.
>> >
>>
>> You need
>>
>> http://git.kernel.org/?p=linux/kernel/git/hjl/linux-2.6.37.y.git;a=commitdiff;h=2c5ce9c1b8eb927c131a31d4466e24e00647e9cb
>
> That doesn't fix the similar entry_32.S problem.  Here you go.
>
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index c8b4efa..9ca3b0e 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1413,7 +1413,7 @@ ENTRY(async_page_fault)
>        CFI_ADJUST_CFA_OFFSET 4
>        jmp error_code
>        CFI_ENDPROC
> -END(apf_page_fault)
> +END(async_page_fault)
>  #endif
>
>  /*
>

The assembler error message is very vague about mismactched
.size location.  I guess we don't have the infrastructure to provide
better diagnostics.

-- 
H.J.
