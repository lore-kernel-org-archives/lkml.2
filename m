Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab2JTBrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:47:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933234Ab2JTBrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:47:41 -0400
X-IronPort-AV: E=Sophos;i="4.80,618,1344182400"; 
   d="scan'208";a="6033514"
Message-ID: <5081F565.8020605@cn.fujitsu.com>
Date: Sat, 20 Oct 2012 08:50:45 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Wen Congyang <wencongyang@gmail.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/10] memory-hotplug : check whether memory is offline
 or not when removing memory
References: <506E43E0.70507@jp.fujitsu.com> <506E451E.1050403@jp.fujitsu.com> <CAHGf_=rVDm-JygjPoLHbmF28Dgd52HFc4-b5KCxhEieG60okuw@mail.gmail.com> <50812F13.20503@cn.fujitsu.com> <5081609C.9080702@gmail.com> <CAHGf_=q=Agidyj_j6jhBdhNmJBy2u1dP+UMAoXbM=_=DyZJs_w@mail.gmail.com>
In-Reply-To: <CAHGf_=q=Agidyj_j6jhBdhNmJBy2u1dP+UMAoXbM=_=DyZJs_w@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/20 08:44:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/20 08:45:29,
	Serialize complete at 2012/10/20 08:45:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/20/2012 02:33 AM, KOSAKI Motohiro Wrote:
>> I think it again, and found that this check is necessary. Because we only
>> lock memory hotplug when offlining pages. Here is the steps to offline and
>> remove memory:
>>
>> 1. lock memory hotplug
>> 2. offline a memory section
>> 3. unlock memory hotplug
>> 4. repeat 1-3 to offline all memory sections
>> 5. lock memory hotplug
>> 6. remove memory
>> 7. unlock memory hotplug
>>
>> All memory sections must be offlined before removing memory. But we don't
>> hold
>> the lock in the whole operation. So we should check whether all memory
>> sections
>> are offlined before step6.
> 
> You should describe the race scenario in the patch description. OK?
> 

OK

Thanks
Wen Congyang
