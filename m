Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab0JLKsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:48:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39679 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab0JLKsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:48:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LS8tEO1U3DuBtmzglf91OrLgRvt2gi1hzmIWd6QoZXdh07+l7phQ5tdJVQGY+ljNjw
         f8lrYW4XSGHNpgnWp73Q5W/vJGGiW5bi2WNLePBfd4B6SFs5fpPxU0mCFU4CHS8UvFQN
         oeVyHIlm11zEGGB6wtYruMPPos8iwbpXs2DQE=
MIME-Version: 1.0
In-Reply-To: <20101012074522.GA20436@basil.fritz.box>
References: <4CB1EBA2.8090409@gmail.com>
	<87aamm3si1.fsf@basil.nowhere.org>
	<4CB34A1A.3030003@gmail.com>
	<20101012074522.GA20436@basil.fritz.box>
Date: Tue, 12 Oct 2010 12:47:39 +0200
Message-ID: <AANLkTinpoL+AMU62PMvXs78Y6v0efDm3eq++NiVk8XUB@mail.gmail.com>
Subject: Re: [PATCH 14(16] pramfs: memory protection
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/12 Andi Kleen <andi@firstfloor.org>:
> On Mon, Oct 11, 2010 at 07:32:10PM +0200, Marco Stornelli wrote:
>> Il 10/10/2010 18:46, Andi Kleen ha scritto:
>> > This won't work at all on x86 because you don't handle large
>> > pages.
>> >
>> > And it doesn't work on x86-64 because the first 2GB are double
>> > mapped (direct and kernel text mapping)
>> >
>> > Thirdly I expect it won't either on architectures that map
>> > the direct mapping with special registers (like IA64 or MIPS)
>>
>> Andi, what do you think to use the already implemented follow_pte
>> instead?
>
> Has all the same problems. Really you need an per architecture
> function. Perhaps some architectures could use a common helper,
> but certainly not all.
>

per-arch?! Wow. Mmm...maybe I have to change something at fs level to
avoid that. An alternative could be to use the follow_pte solution but
avoid the protection via Kconfig if the fs is used on some archs (ia64
or MIPS), with large pages and so on. An help of the kernel community
to know all these particular cases is welcome.

Regards,

Marco
