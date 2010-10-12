Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab0JLOF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 10:05:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:55133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932477Ab0JLOF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 10:05:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,320,1283756400"; 
   d="scan'208";a="615913190"
From: "Ma, Ling" <ling.ma@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 12 Oct 2010 22:05:54 +0800
Subject: RE: [RFC PATCH] [X86/mem] Handle unaligned case by avoiding store
 crossing cache line
Thread-Topic: RE: [RFC PATCH] [X86/mem] Handle unaligned case by avoiding
 store crossing cache line
Thread-Index: ActqFpWmW2MkIjWxTjOZ8TRxRQt/ow==
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F15CBF9E72A@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>         * Use 32bit CMP here to avoid long NOP padding.
>>         */
>> -       cmp  $0x20, %edx
>> +       cmp  $0x28, %rdx
>
>Well, look above your change. The comment says "Use 32bit CMP".
>If you really want to go to 64-bit one, then change comment too.

Yes, change next version. In this version we use 64bit is for Lcopy_forward_loop
become 16bit aligned without Nop padding.
 
>> +       /*
>> +        * We append data to avoid store crossing cache.
>> +        */
>> +       movq (%rsi), %rcx
>> +       movq %rdi, %r8
>> +       addq $8, %rdi
>> +       andq $-8, %rdi
>> +       movq %rcx, (%r8)
>> +       subq %rdi, %r8
>> +       addq %r8, %rdx
>> +       subq %r8, %rsi

>The comment doesn't really help to understand what you are doing here.
>Maybe "Align store location to 32 bytes to avoid crossing cachelines"?

Ok change in next version. Here by overlap writing we force store to handle data
with 8bytes aligned later. If store can handle memory with aligned 8bytes,
it never cross cache line in one operation because cache line size should be 
multiple of 8bytes.

Thanks
Ling

