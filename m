Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2FSHSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:18:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44421 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2FSHSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <4FDFCED7.90109@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	<1339741902-8449-9-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBScO2DBL=tQ+RNfNfS4X3bvbHsp9CBrYQOP_uQu0bGhnw@mail.gmail.com>
	<4FDFCED7.90109@intel.com>
Date: Tue, 19 Jun 2012 09:18:09 +0200
Message-ID: <CABPqkBSg+isxVD1xFVrszJY3aJU9a-qC93DVRtAbC-3XfzXGsg@mail.gmail.com>
Subject: Re: [PATCH V6 08/13] perf: Add Sandy Bridge-EP uncore support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 2:59 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> On 06/18/2012 11:28 PM, Stephane Eranian wrote:
>> On Fri, Jun 15, 2012 at 8:31 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>>> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
>>> >
>>> > Add Intel Nehalem and Sandy Bridge uncore pmu support. The uncore
>>> > subsystem in Sandy Bridge-EP consists of 8 components (Ubox,
>>> > Cacheing Agent, Home Agent, Memory controller, Power Control,
>>> > QPI Link Layer, R2PCIe, R3QPI).
>>> >
>> I did not find in this patch the support for the C-Box Filter register
>> (SNBEP_C0_MSR_PMON_BOX_FILTER). Based on the description
>> in the manual, looks like a valuable filter to support, especially for
>> the core/thread filtering capability.
>>
>> There is only one such filter per box, and it can be used by any events.
>> So looks like we have another offcore_resp style register to manage
>> here. Need to ensure the value of that filter is shared by all 4 counters.
>> If you were to support that, you'd have to enable the tid filter on the
>> CBox config regs and export that via sysfs. Also I assume you'd
>> pass the value of that filter either in config1 or in the upper 32 bits
>> of the config reg.
>>
>> What's your take on that?
>>
>
> I'm working on uncore support for Nehalem-EX which has extensive use of
> shared extra registers. Once that work done, adding C-Box filter support
> should be easy.
>
Ok. Note that the code logic to handle shared regs is already there and is
used for OFFCORE_RSP*, LBR_SELECT and LD_LAT (soon). Would be
nice to reuse that framework for this as well. Though I understand you're
looking at per box sharing as opposed to per physical core sharing or
cross HT sharing.

> Regards
> Yan, Zheng
>
>
>
