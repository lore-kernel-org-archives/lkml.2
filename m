Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1CRIp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:45:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38361 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab1CRIpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rubyvgfWvAMLDTgwh+mBfGzCW+komD/EVlIKFGZdaNn+0oDDSNk2FKfQEQKANAcQvc
         UKChwF2mt1DICKmyaMB9g6PT9BnrPrrVh+Emgxmi8fuGbJQrS8grG9ZXsk+wa76UiSYQ
         xW/cpIJRs8EGwaRWG2CrCQ2kQkNvQfK78NE4A=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103171344270.26889@xanadu.home>
References: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com>
 <1300169637-1628-1-git-send-email-ratbert.chuang@gmail.com>
 <alpine.LFD.2.00.1103171301030.26889@xanadu.home> <AANLkTik1oEkLX3R-adK9-_2W+ku4j9YDikr+Z4vzfGtb@mail.gmail.com>
 <alpine.LFD.2.00.1103171344270.26889@xanadu.home>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Fri, 18 Mar 2011 16:44:44 +0800
Message-ID: <AANLkTi=Zq0fiVf+GcRC8M+CPakwmEWn1rrqq_U4OehNy@mail.gmail.com>
Subject: Re: [PATCH v2] arm: cmpxchg syscall should data abort if page not write
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ashwin Chaugule <ashbertslists@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Po-Yu Chuang <ratbert@faraday-tech.com>, tony@atomide.com,
        lkml <linux-kernel@vger.kernel.org>, joe@perches.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Nicolas Pitre,

On Fri, Mar 18, 2011 at 1:57 AM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Thu, 17 Mar 2011, Ashwin Chaugule wrote:
>>
>> Just beginning to understand the subtleties involved, so please
>> correct me if I'm wrong.
>> Wont this patch also fix the problem that was brought up with futexes
>> on ARM SMP ?
>
> Nope.  The code being fixed here was suptly broken so it needs fixing.
> However this code is almost never used, if at all, as it is a fall-back
> solution for when all the better alternatives are not available for some
> reasons (and I'm still wondering what those reasons are for Po-Yu Chuang
> to actually use that code).  In practice this bug should have affected
> no one.

We met this problem while porting an v5 SMP processor because kernel
selects NEEDS_SYSCALL_FOR_CMPXCHG by default if CPU_32v5.

After we added our own implementation of __kuser_cmpxchg, this code
is not needed anymore. But since this is actually a bug, it is still a good
idea to submit a patch. :-)

> If you have SMP then this code is definitively not what you should be
> using.

Best regards,
Po-Yu Chuang
