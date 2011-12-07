Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab1LGEWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 23:22:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55895 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab1LGEWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 23:22:53 -0500
MIME-Version: 1.0
In-Reply-To: <1323124508.32012.46.camel@twins>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	<1318595833-29984-6-git-send-email-eranian@google.com>
	<1323124508.32012.46.camel@twins>
Date: Tue, 6 Dec 2011 20:22:52 -0800
Message-ID: <CABPqkBSKhcB+jAzfy7HJ_j1u5qz59eGoTzZzsgHhMwdYBkT2Fw@mail.gmail.com>
Subject: Re: [PATCH 05/12] perf_events: add LBR mappings for
 PERF_SAMPLE_BRANCH filters (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 2:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
>>  void intel_pmu_lbr_init_atom(void)
>>  {
>> +       /*
>> +        * only models starting at stepping 10 seems
>> +        * to have an operational LBR which can freeze
>> +        * on PMU interrupt
>> +        */
>> +       if (boot_cpu_data.x86_mask < 10) {
>> +               pr_cont("LBR disabled due to erratum");
>> +               return;
>> +       }
>
> Shouldn't that be a separate patch?

I'll make it into a separate patch.
