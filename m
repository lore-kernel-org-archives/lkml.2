Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2F1GCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:02:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53882 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2F1GCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:02:03 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEBF342.9030303@jp.fujitsu.com>
Date: Thu, 28 Jun 2012 15:01:38 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-acpi@vger.kernel.org>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 2/12] memory-hogplug : check memory offline in offline_pages
References: <4FEA9C88.1070800@jp.fujitsu.com> <4FEA9DB1.7010303@jp.fujitsu.com> <4FEAC916.7030506@cn.fujitsu.com> <4FEBE646.5090801@jp.fujitsu.com> <CAHGf_=rzRthh+hpKWAVF9OyL+P_NhFw4y+W-tF3j0zB8pr0QjA@mail.gmail.com>
In-Reply-To: <CAHGf_=rzRthh+hpKWAVF9OyL+P_NhFw4y+W-tF3j0zB8pr0QjA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki-san,

2012/06/28 14:27, KOSAKI Motohiro wrote:
> On Thu, Jun 28, 2012 at 1:06 AM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> Hi Wen,
>>
>> 2012/06/27 17:49, Wen Congyang wrote:
>>> At 06/27/2012 01:44 PM, Yasuaki Ishimatsu Wrote:
>>>> When offline_pages() is called to offlined memory, the function fails since
>>>> all memory has been offlined. In this case, the function should succeed.
>>>> The patch adds the check function into offline_pages().
>>>
>>> You miss such case: some pages are online, while some pages are offline.
>>> offline_pages() will fail too in such case.
>>
>> You are right. But current code fails, when the function is called to offline
>> memory. In this case, the function should succeed. So the patch confirms
>> whether the memory was offlined or not. And if memory has already been
>> offlined, offline_pages return 0.
>
> Can you please explain why the caller can't check it? I hope to avoid
> an ignorance
> as far as we can.

Of course, caller side can check it. But there is a possibility that
offline_pages() is called by many functions. So I do not think that it
is good that all functions which call offline_pages() check it.

Thanks,
Yasuaki Ishimatsu

