Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242Ab1D2QnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:43:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57999 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212Ab1D2QnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=u/q3kbvdITst4kbNWmM/gWpYGrEpJRSKj0cwh/JHGhlGRBpruqdzYA1LuW9XGRzkNu
         00rjDP/D559IWk+PxjlsyRiSSH8vXxWiKQa/4/PCdfVGG4dngsIXilgKWwJrkguygCOB
         4GG5BqWX3Q1UYJE+OiDbAJfiB3dH5GzyRWMp8=
MIME-Version: 1.0
In-Reply-To: <201104291741.18190.arnd@arndb.de>
References: <201104212129.17013.arnd@arndb.de>
	<201104271243.16868.arnd@arndb.de>
	<1303902508.15101.21.camel@e102109-lin.cambridge.arm.com>
	<201104291741.18190.arnd@arndb.de>
Date: Fri, 29 Apr 2011 17:42:59 +0100
X-Google-Sender-Auth: IGVvG2yWheLCFyCFPlsO8kIanlw
Message-ID: <BANLkTimJoc_DR3bjxehDFcTM13CavAX_=A@mail.gmail.com>
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 April 2011, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 27 April 2011, Catalin Marinas wrote:
>> > >
>> > > It's not broken since we moved to using Normal non-cacheable memory
>> > > for the coherent DMA buffers (as long as you flush the cacheable alias
>> > > before using the buffer, as we already do). The ARM ARM currently says
>> > > unpredictable for such situations but this is being clarified in
>> > > future updates and the Normal non-cacheable vs cacheable aliases can
>> > > be used (given correct cache maintenance before using the buffer).
>> >
>> > Thanks for that information, I believe a number of people in the
>> > previous discussions were relying on the information from the
>> > documentation. Are you sure that this is not only correct for the
>> > cores made by ARM ltd but also for the other implementations that
>> > may have relied on documentation?
>>
>> It is a clarification in the ARM ARM so it covers all the cores made by
>> architecture licensees, not just ARM Ltd. It basically makes the
>> "unpredictable" part more predictable to allow certain types of aliases
>> (e.g. Strongly Ordered vs Normal memory would still be disallowed).
>>
>> All the current implementations are safe with Normal memory aliases
>> (cacheable vs non-cacheable) but of course, there may be some
>> performance benefits in not having any alias.
>
> A lot of the discussions we are about to have in Budapest will be
> around solving the problem of having only valid combinations of
> mappings, so we really need to have a clear statement in specification
> form about what is actually valid.
>
> Would it be possible to have an updated version of the relevant
> section of the ARM ARM by next week so we can use that as the
> base for our discussions?

I'll ask the architecture people here in ARM and get back to you
(there is holiday until Tuesday next week in the UK).

-- 
Catalin
