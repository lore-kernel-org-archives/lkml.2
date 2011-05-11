Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1EKPgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:36:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab1EKPgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:36:44 -0400
Message-ID: <4DCA76D7.2010608@redhat.com>
Date: Wed, 11 May 2011 14:45:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, core: Introduce attrs to count in either host
 or guest mode
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com> <1305038132-5080-2-git-send-email-joerg.roedel@amd.com> <4DCA76A5.7030000@redhat.com>
In-Reply-To: <4DCA76A5.7030000@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 02:44 PM, Avi Kivity wrote:
> On 05/10/2011 05:35 PM, Joerg Roedel wrote:
>> The two new attributes exclude_guest and exclude_host can
>> bes used by user-space to tell the kernel to setup
>> performance counter to either only count while the CPU is in
>> guest or in host mode.
>> An additional check is also introduced to make sure
>> user-space does not try to exclude guest and host mode from
>> counting.
>>
>> @@ -217,7 +217,10 @@ struct perf_event_attr {
>>                   mmap_data      :  1, /* non-exec mmap data    */
>>                   sample_id_all  :  1, /* sample_type all events */
>>
>> -                __reserved_1   : 45;
>> +                exclude_host   :  1, /* don't count in host   */
>> +                exclude_guest  :  1, /* don't count in guest  */
>> +
>> +                __reserved_1   : 43;
>>
>
> We have exclude_hv a few lines up, so only exclude_guest is needed.
>

Well, actually, that depends on the meaning of exclude_hv.

-- 
error compiling committee.c: too many arguments to function

