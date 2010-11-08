Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0KHQny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:43:54 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:49535 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0KHQnx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Mon, 8 Nov 2010 11:43:53 -0500
Message-Id: <4CD836D40200007800020F4E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 08 Nov 2010 16:43:48 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: more fixes and cleanup to AMD Fam10 MMCONF
	 enabling
References: <4CD3F18E0200007800020B6D@vpn.id2.novell.com>
 <4CD82195.6080905@zytor.com>
In-Reply-To: <4CD82195.6080905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 08.11.10 at 17:13, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 11/05/2010 03:59 AM, Jan Beulich wrote:
>>  
>> --- 2.6.37-rc1-x86_64-mmconf-fam10h.orig/arch/x86/kernel/mmconf-fam10h_64.c
>> +++ 2.6.37-rc1-x86_64-mmconf-fam10h/arch/x86/kernel/mmconf-fam10h_64.c
>> @@ -43,7 +43,7 @@ static int __cpuinit cmp_range(const voi
>>  	return start1 - start2;
>>  }
>>  
>> -#define UNIT (1ULL << (5 + 3 + 12))
>> +#define UNIT (1ULL << FAM10H_MMIO_CONF_BASE_SHIFT)
>>  #define MASK (~(UNIT - 1))
>>  #define SIZE (UNIT << 8)
> 
> Could we avoid macros named UNIT, MASK, and SIZE at all?  I realize
> they're already in the code, but still...

I could understand if these were definition in a header, but why
do you think we need to have unnecessarily long identifiers (e.g.
by prefixing all of the defines here with FAM10H_MMIO_CONF_BASE_)
in places like this? After all, one of the two goals of using a macro
here at all is to keep things small and simple...

But sure, if just the names hinder acceptance, I can fold this and
the original patches together and use less ambiguous names.

Jan

