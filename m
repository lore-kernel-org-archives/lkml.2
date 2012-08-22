Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab2HVHya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:54:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:57336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab2HVHyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:54:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,808,1336374000"; 
   d="scan'208";a="183726431"
Message-ID: <50349012.3010508@intel.com>
Date: Wed, 22 Aug 2012 15:53:54 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <jbeulich@suse.com>
CC: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: apparent regressions from TLB range flushing page set
References: <503261F00200007800096710@nat28.tlf.novell.com> <5034516E.60908@intel.com> <50349BF6020000780008A4C6@nat28.tlf.novell.com>
In-Reply-To: <50349BF6020000780008A4C6@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 03:44 PM, Jan Beulich wrote:

>>>> Alex Shi <alex.shi@intel.com> 08/22/12 5:27 AM >>>
>>> Second, the UV code doesn't flush the full range at all, it simply
>>> ignores its 'end' parameter (and hence also the "all" indicator).
>>
>> Sure. the following rfc patch try to fix it. untested since no hardware.
> 
> Sure - this needs to be looked at by a person knowing UV (and I would
> have thought a change like the one we're discussing here would also
> have required an ack from such a person), but ...
> 
>> --- a/arch/x86/platform/uv/tlb_uv.c
>> +++ b/arch/x86/platform/uv/tlb_uv.c
>> @@ -280,12 +280,12 @@ static void bau_process_message(struct msg_desc *mdp, struct bau_control *bcp,
>>    /*
>>     * This must be a normal message, or retry of a normal message
>>     */
>> -    if (msg->address == TLB_FLUSH_ALL) {
>> +    if (msg->end == 0) {
> 
> How would "end" end up being 0 here? Don't you rather mean "start and
> end on the same page"?


yes,

> And even if you do, aren't you then losing the
> intended optimization?


Sure, TLB optimization is relatively complex and specific on different
hardware. I am not sure this platform needs this, and even so, I can not
give reasonable flushall_shift value. So, it is better to recover the
system as before.

