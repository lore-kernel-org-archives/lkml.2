Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0HRJmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:42:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47240 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab0HRJmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=S42bZPXNwmo0Z51wZ+Q6dUO2rHrAUgj9KSFXZZuqymDYPDfOg7aUPDTsyU0rcL1goj
         6Qfw+z7ds7uyZqwINiHaVlMkmzBHxwuKbwlxbJ56fEdMB8DAeAa7eaJDlZ4VTdZrABEy
         d3BMPYgI5ebeiFQX7ymZs6QUDsmmntxPip5fg=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <AANLkTinbr9OKeSvVsZe8dRodgwFeQu28wp6A8kmuXsP0@mail.gmail.com>
References: <1282117561.11858.54.camel@minggr.sh.intel.com>
	<AANLkTinbr9OKeSvVsZe8dRodgwFeQu28wp6A8kmuXsP0@mail.gmail.com>
Date: Wed, 18 Aug 2010 11:42:17 +0200
Message-ID: <AANLkTimD+nF_GD=DN=-mLdPj_xqwuvy_DZqHCwtwZSed@mail.gmail.com>
Subject: Re: libpfm4 faults on P4 machine
From: stephane eranian <eranian@googlemail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        perfmon2-devel@lists.sourceforge.net,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 11:21 AM, stephane eranian
<eranian@googlemail.com> wrote:
> Lin,
>
> It should not have chosen  intel_x86_arch to begin with.
> That's where the bug is. Let me fix this.
>
>
Fixed in the git tree, just pull again.
Thanks for reporting this issue.

> On Wed, Aug 18, 2010 at 9:46 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>> On P4 machine, intel_x86_arch_support.get_event_info(...) faults because
>> intel_x86_arch_support.pe is NULL.
>>
>> intel_x86_arch_support.pe is set at run time, but P4 does not have arch
>> event support, so intel_x86_arch_support.pe is always NULL.
>>
>> #gdb libpfm4/examples/check_events
>>
>> Program received signal SIGSEGV, Segmentation fault.
>> [Switching to Thread 0xb785caf0 (LWP 3950)]
>> 0x0804d74b in pfm_intel_x86_get_event_info (this=0x81c5f80, idx=0, info=0xbff45f14)
>>    at pfmlib_intel_x86.c:667
>> 667             info->desc  = pe[idx].desc;
>> (gdb) bt
>> #0  0x0804d74b in pfm_intel_x86_get_event_info (this=0x81c5f80, idx=0, info=0xbff45f14)
>>    at pfmlib_intel_x86.c:667
>> #1  0x08049cd3 in pfmlib_parse_event (event=0x804fb7b "PERF_COUNT_HW_CPU_CYCLES", d=0xbff45f7c)
>>    at pfmlib_common.c:676
>> #2  0x08049f3f in pfm_get_event_encoding (str=0x804fb7b "PERF_COUNT_HW_CPU_CYCLES", dfl_plm=8,
>>    fstr=0xbff464d4, idx=0xbff464c8, codes=0xbff464d0, count=0xbff464cc) at pfmlib_common.c:877
>> #3  0x08048dc1 in main (argc=<value optimized out>, argv=0xbff46584) at check_events.c:118
>> (gdb) list
>> 662
>> 663             /*
>> 664              * pmu and idx filled out by caller
>> 665              */
>> 666             info->name  = pe[idx].name;
>> 667             info->desc  = pe[idx].desc;
>> 668             info->code  = pe[idx].code;
>> 669             info->equiv = pe[idx].equiv;
>> 670
>> 671             /* unit masks + modifiers */
>> (gdb)
>>
>> Any fix?
>>
>> Lin Ming
>>
>>
>
