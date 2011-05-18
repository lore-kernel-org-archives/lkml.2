Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1ERVro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:47:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54603 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab1ERVrm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Yrk8O9tw2HmhCbXVMjzxcLaxTaJ4vszsglIl7nzMkc8zKGylvwKH50fuBa4joOIpH5
         +tVfh8UWu0N+SOProeNezyh1/sOEVESwZR9Gf7JkYZ8oShi+YrRAOR/mDGFchRj5I6+E
         3MQKvjUK1FeWUswRDqMcHOSNGS6gWZPhcknio=
MIME-Version: 1.0
In-Reply-To: <20110518155615.GJ15292@game.jcrosoft.org>
References: <201105181047.17309.arnd@arndb.de>
	<20110518155615.GJ15292@game.jcrosoft.org>
Date: Wed, 18 May 2011 22:47:41 +0100
X-Google-Sender-Auth: 1yO3wjtpxSKf7eVXkVhOPQXl84U
Message-ID: <BANLkTi=LKYrhZkiAeLJH8VF4LkKnOr--zg@mail.gmail.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 18 May 2011, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 10:47 Wed 18 May     , Arnd Bergmann wrote:
>> This is the draft plan for maintaining the ARM subarchitectures in a common
>> tree, as a way to help coordinate the upstream merging of the
>> arch/arm/{plat,mach}-* changes into Linus' tree.
>
> How do you plan to manage with already sub arch maintainers?
>
> In my ming such tree could be good to organise cross arch drivers
> but for real arch specific the current workflow is good
>
> If we add a new stage it will be difficult to follow for people
>
> I'd like to have scenario example where such workflow will give a significant
> advantage compare to the current workflow. And please real example.

I'll let Arnd and the other members of this group come up with real
examples. In the meantime I'll give my view on this.

The aim is not to hide existing sub-architecture patches behind
another git tree so that people won't notice the conflicts. It's not
just a workflow change, the Acked-by mechanism may have worked as
well, though some people may skip it (even unintentionally).

There is a lot of code duplication between various sub-architectures
under arch/arm/ and this group, together with the sub-arch
maintainers, will try to consolidate this, move common code out into
drivers/ so that it can be easily shared, start moving platforms to
FDT etc. (they could give a roadmap but it's early stages now). This
needs to be a coordinated effort and the group will ensure that the
general direction of code reduction is followed by all the current and
new sub-arch maintainers.

A lot of platform ports have been done just by copying existing code
without any effort in exploiting the commonality. This could be
spotted much easier with a dedicated group of people and guide the
sub-arch maintainers in the write direction. It may be even quicker
for them to get code merged into drivers/ where applicable.

I expect the activity of this group to be reduced in the future, once
the consolidation work is complete (but that's not a trivial task). At
that point maybe one or two people would just keep an eye on what gets
pushed into mainline in sub-arch directories and sub-arch maintainers
would just work as before, sending pull requests to Linus directly.

As the incentive for existing sub-arch maintainers to agree with this
strategy - given Linus' recent comments on the ARM sub-arch trees, it
is possible that he won't merge such trees pushed directly to him if
they don't show a consistent direction towards code consolidation. I
think this group and tree would actually make upstream pushing
quicker.

-- 
Catalin
