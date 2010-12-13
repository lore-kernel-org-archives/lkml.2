Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab0LMOj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:39:26 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:45682 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0LMOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:39:24 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFu+BU2rR7H+/2dsb2JhbACkAninJZp2hUoEhGSGFYMU
X-IronPort-AV: E=Sophos;i="4.59,336,1288569600"; 
   d="scan'208";a="301508643"
Message-ID: <4D06301C.2090309@cisco.com>
Date: Mon, 13 Dec 2010 07:39:24 -0700
From: "David S. Ahern" <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
References: <1291773285-16254-1-git-send-email-daahern@cisco.com> <1291773285-16254-2-git-send-email-daahern@cisco.com> <20101212201613.GA1784@nowhere>
In-Reply-To: <20101212201613.GA1784@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/10 13:16, Frederic Weisbecker wrote:

>>  int perf_session__create_kernel_maps(struct perf_session *self)
>>  {
>>  	int ret = machine__create_kernel_maps(&self->host_machine);
>> @@ -167,6 +190,9 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
>>  		 */
>>  		if (perf_session__create_kernel_maps(self) < 0)
>>  			goto out_delete;
>> +
>> +		if (perf_session__create_ref_time(self) < 0)
>> +			goto out_delete;
> 
> So, it does record it anytime?

Simplest to always add it the header as it does no harm if not used. To
make it conditional means adding an input parameter to
perf_session__new() and then updating all the callers.

Is the preference to make it conditional?

David


> 
>>  	}
>>  
>>  	perf_session__update_sample_type(self);
> 
> 
> Other than that, looks good!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
