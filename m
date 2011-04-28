Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab1D1Ljr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 07:39:47 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:59164 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab1D1Ljq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:3>);
	Thu, 28 Apr 2011 07:39:46 -0400
Message-Id: <4DB96E6A020000780003E9EB@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 28 Apr 2011 12:40:58 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-arch@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] allow placing exception table in .rodata (and do
	 so on  x86)
References: <4DB85404020000780003E6D7@vpn.id2.novell.com>
 <20110428104306.GC2431@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20110428104306.GC2431@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.04.11 at 12:43, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> On Wed, Apr 27, 2011 at 04:36:04PM +0100, Jan Beulich wrote:
>> This is since the table is really a set of pointers, i.e. misplaced in
>> .text.
>> 
>> Quite likely other architectures would want to follow.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> 
> 
> [...]
> 
>> --- 2.6.39-rc5/include/asm-generic/vmlinux.lds.h
>> +++ 2.6.39-rc5-extable-in-rodata/include/asm-generic/vmlinux.lds.h
>> @@ -226,6 +226,7 @@
>>  		*(.rodata1)						\
>>  	}								\
>>  									\
>> +	EXCEPTION_TABLE_RO						\
> 
> That's odd. The kernel actually writes to it (sort_main_extable()), so
> it shouldn't be in the ro data section, but the data section.

This area does get written, but only at boot time, before read-only
data gets set to r/o (on x86 at least). With this in mind, it's better
to place it in .rodata, as that way run-time protection will be in place
(and I think you agree that it was misplaced in .text in any case).

Jan

>>  	JUMP_TABLE							\
> 
> same here.



