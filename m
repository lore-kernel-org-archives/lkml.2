Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2BSLNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 06:13:21 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53062 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab2BSLNU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 06:13:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.112.31.232 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <20120216045749.GA25364@bloggs.ozlabs.ibm.com>
References: <20120216154822.5bfad11d@kryten>
	<20120216045749.GA25364@bloggs.ozlabs.ibm.com>
Date: Sun, 19 Feb 2012 12:13:18 +0100
Message-ID: <CABPqkBR=Sv79YqnCG+374WdNcAJgk9VvZr7JCPxNebYMzD4Jrw@mail.gmail.com>
Subject: Re: [PATCH] powerpc: perf: power_pmu_start restores incorrect values,
 breaking frequency events
From: Stephane Eranian <eranian@google.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>, peterz@infradead.org, mingo@elte.hu,
        gleb@redhat.com, wcohen@redhat.com, vince@deater.net, asharma@fb.com,
        andi@firstfloor.org, emunson@mgebm.net, imunsie@au1.ibm.com,
        benh@kernel.crashing.org, sukadev@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glad to see you fixed the PPC problem.

On Thu, Feb 16, 2012 at 5:57 AM, Paul Mackerras <paulus@samba.org> wrote:
> On Thu, Feb 16, 2012 at 03:48:22PM +1100, Anton Blanchard wrote:
>>
>> perf on POWER stopped working after commit e050e3f0a71b (perf: Fix
>> broken interrupt rate throttling). That patch exposed a bug in
>> the POWER perf_events code.
>>
>> Since the PMCs count upwards and take an exception when the top bit
>> is set, we want to write 0x80000000 - left in power_pmu_start. We were
>> instead programming in left which effectively disables the counter
>> until we eventually hit 0x80000000. This could take seconds or longer.
>>
>> With the patch applied I get the expected number of samples:
>>
>> # taskset -c 0 yes > /dev/null &
>> # perf record -C 0 -a sleep 10
>> # perf report -D | grep SAMPLE | tail -1
>>           SAMPLE events:       9948
>>
>> Signed-off-by: Anton Blanchard <anton@samba.org>
>
> Acked-by: Paul Mackerras <paulus@samba.org>
