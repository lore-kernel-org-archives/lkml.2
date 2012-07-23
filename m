Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2GWHC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:02:27 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:48929 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab2GWHC0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 23 Jul 2012 03:02:26 -0400
Message-Id: <500D131C020000780008FC3E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 23 Jul 2012 08:02:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] x86: adjust generic_get_mtrr() for 64-bit
References: <4FF70EFC020000780008E195@nat28.tlf.novell.com>
 <CAE9FiQUNC2e03k=ECkQQU4732mGL-xidDyauAy0CdWjDg=EG8Q@mail.gmail.com>
In-Reply-To: <CAE9FiQUNC2e03k=ECkQQU4732mGL-xidDyauAy0CdWjDg=EG8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.07.12 at 23:38, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jul 6, 2012 at 7:14 AM, Jan Beulich <JBeulich@suse.com> wrote:
>> Needing to deal with potentially large memory configurations, the
>> variables here should be "unsigned long" instead of "unsigned int".
>>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>
>> ---
>>  arch/x86/kernel/cpu/mtrr/generic.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> --- 3.5-rc5/arch/x86/kernel/cpu/mtrr/generic.c
>> +++ 3.5-rc5-x86-mtrr-generic-types/arch/x86/kernel/cpu/mtrr/generic.c
>> @@ -514,8 +514,8 @@ generic_get_free_region(unsigned long ba
>>  static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>>                              unsigned long *size, mtrr_type *type)
>>  {
>> -       unsigned int mask_lo, mask_hi, base_lo, base_hi;
>> -       unsigned int tmp, hi;
>> +       unsigned long mask_lo, mask_hi, base_lo, base_hi, tmp;
>> +       unsigned int hi;
> 
> _lo, _hi means we want it as 32bit.
> 
> or we just change them to u32 to make it more clear ?

Agreed, it's really only "tmp" that needs to be "unsigned long".
I'll send out a v2 soon, at once converting lo/hi to u32.

Jan

