Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1EVVJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 17:09:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34535 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab1EVVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 17:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JZX2dJ17qRf0STmbq8/SVb8brhSyZ5WBeSKN+ruVLPs+Q4E9O+rTvLxtF5hjhSrLn9
         jsyu/Q1X92HyIGdTpsli0+XA4cUQEbtqr8/deLN0V3lLbKjfIJ8MegcDTftybxLmhhFc
         2SXTtM58bQXLi0/xTactzPzLqexy6Pz+Q6NZU=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1105201407480.14430@xanadu.home>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
	<1304859098-10760-16-git-send-email-catalin.marinas@arm.com>
	<20110518072737.GC6815@atomide.com>
	<1305897667.2788.98.camel@e102109-lin.cambridge.arm.com>
	<alpine.LFD.2.00.1105201407480.14430@xanadu.home>
Date: Sun, 22 May 2011 22:09:47 +0100
X-Google-Sender-Auth: 8yGjzj9W650hkR1BMswfQov4NUA
Message-ID: <BANLkTimC7dC3P9NQC8BuED9HbdmP1nbZhQ@mail.gmail.com>
Subject: Re: [PATCH v5 15/19] ARM: LPAE: Add support for cpu_v7_do_(suspend|resume)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2011 19:09, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Fri, 20 May 2011, Catalin Marinas wrote:
>> On Wed, 2011-05-18 at 08:27 +0100, Tony Lindgren wrote:
>> > Do we really need all this ifdef else throughout this series?
>> >
>> > I think we already have things in place to do this dynamically
>> > like we already do for thumb, smp_on_up, v6 vs v7 and so on.
>>
>> By dynamically, do you mean at run-time? We won't be able to compile
>> both classic and LPAE in the same kernel, there is just too much
>> difference between them (2 vs 3 levels of page tables - LPAE is an
>> entirely new format).
>>
>> If you mean some simpler macros like what we have for ARM/THUMB to
>> reduce the number of lines, I'm fine with it though we don't always have
>> a 1:1 mapping between LPAE and non-LPAE instructions.
>>
>> Alternatively, I'm happy to create a separate proc-v7lpae.S file.
>
> That would probably be the best option.

OK, I'll move this code to a separate file. The v7 setup code got
pretty hard to read.

-- 
Catalin
