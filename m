Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab2CGNOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:14:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:35757 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab2CGNOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:14:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="134929907"
Message-ID: <4F575F09.3010107@intel.com>
Date: Wed, 07 Mar 2012 21:13:45 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: gcc@gcc.gnu.org, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com, gcc-help@gcc.gnu.org
Subject: Re: [RFC patch] spindep: add cross cache lines checking
References: <1330917630.18835.44.camel@debian> <201203060932.45223.arnd@arndb.de> <1331108607.18835.343.camel@debian> <201203071154.36059.arnd@arndb.de>
In-Reply-To: <201203071154.36059.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think the check should be (__alignof__(lock) < __alignof__(rwlock_t)),
> otherwise it will still pass when you have structure with attribute((packed,aligned(2)))


reasonable!

> 
>> 1, it is alignof bug for default gcc on my fc15 and Ubuntu 11.10 etc?
>>
>> struct sub {
>>         int  raw_lock;
>>         char a;
>> };
>> struct foo {
>>         struct sub z;
>>         int slk;
>>         char y;
>> }__attribute__((packed));
>>
>> struct foo f1;
>>
>> __alignof__(f1.z.raw_lock) is 4, but its address actually can align on
>> one byte. 
> 
> That looks like correct behavior, because the alignment of raw_lock inside of
> struct sub is still 4. But it does mean that there can be cases where the
> compile-time check is not sufficient, so we might want the run-time check
> as well, at least under some config option.


what's your opinion of this, Ingo?
