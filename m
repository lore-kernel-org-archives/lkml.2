Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1JSDGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 23:06:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:39236 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1JSDGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 23:06:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="64400660"
Message-ID: <4E9E3EBB.4080003@linux.intel.com>
Date: Wed, 19 Oct 2011 11:06:35 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Xu, Anhua" <anhua.xu@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: perf tools: interface for improved PEBS ABI can accept wrong
 parameter
References: <1A42CE6F5F474C41B63392A5F80372B212DC93638A@shsmsx501.ccr.corp.intel.com>  <20111018181943.GC21666@elte.hu> <1318962501.14880.6.camel@twins> <1A42CE6F5F474C41B63392A5F80372B212DC9365C1@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <1A42CE6F5F474C41B63392A5F80372B212DC9365C1@shsmsx501.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/10/19 10:23, Xu, Anhua 写道:
> Thanks Peter:). The key point for this is that the detailed information about "PRECISE_IP" may not be exposed to user space.
> Error reporting may come from syscall. Anyway, expect acme's suggestions.
>
>
> -----Original Message-----
> From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> Sent: Wednesday, October 19, 2011 2:28 AM
> To: Ingo Molnar
> Cc: Xu, Anhua; Arnaldo Carvalho de Melo; linux-kernel@vger.kernel.org
> Subject: Re: perf tools: interface for improved PEBS ABI can accept wrong parameter
>
> On Tue, 2011-10-18 at 20:19 +0200, Ingo Molnar wrote:
>>> +#define SAMPLE_IP_MAX        3
>>>                                precise_ip     :  2, /* skid constraint       */
>>>                                mmap_data      :  1, /* non-exec mmap data    */
>>>                                sample_id_all  :  1, /* sample_type all events */
>>> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
>>> index 928918b..a2068cc 100644
>>> --- a/tools/perf/util/parse-events.c
>>> +++ b/tools/perf/util/parse-events.c
>>> @@ -775,7 +775,10 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
>>>        attr->exclude_user   = eu;
>>>        attr->exclude_kernel = ek;
>>>        attr->exclude_hv     = eh;
>>> -     attr->precise_ip     = precise;
>>> +     if ( precise<  SAMPLE_IP_MAX )
>>> +             attr->precise_ip = precise;
>>> +     else
>>> +             return -1;
>
> That name is horrid, how about PRECISE_IP_MAX? Also, I suspect acme will
> want a better error return than -1, but I'll leave that up to him.
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{����zX����ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢf��^jǫy�m��@A�a���0��h��i


Looks like your mail client configuration is bad. Change to another one?
