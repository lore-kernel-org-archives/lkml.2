Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2DJBWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:22:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60315 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2DJBWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:22:48 -0400
X-AuditID: 9c930179-b7b2cae000000ca1-02-4f838b65329d
Message-ID: <4F838BF4.7020104@kernel.org>
Date: Tue, 10 Apr 2012 10:25:08 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Rik van Riel <riel@redhat.com>, hannes@cmpxchg.org
CC: Alexey Ivanov <rbtz@yandex-team.ru>,
        "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, yinghan@google.com
Subject: Re: mapped pagecache pages vs unmapped pages
References: <37371333672160@webcorp7.yandex-team.ru> <4F7E9854.1020904@gmail.com> <12701333991475@webcorp7.yandex-team.ru> <4F8326FD.8020507@redhat.com> <8041334015453@webcorp4.yandex-team.ru> <4F837F6E.3010508@kernel.org> <4F838390.1080909@redhat.com>
In-Reply-To: <4F838390.1080909@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-04-10 오전 9:49, Rik van Riel 쓴 글:

> On 04/09/2012 08:31 PM, Minchan Kim wrote:
>> 2012-04-10 오전 8:50, Alexey Ivanov 쓴 글:
>>
>>> Did you consider making this ratio tunable, at least manually(i.e.
>>> via sysctl)?
>>> I suppose we are not the only ones with almost-whole-ram-mmaped
>>> workload.
>>
>> Personally, I think it's not good approach.
>> It depends on kernel's internal implemenatation which would be changed
>> in future as we chagend it at 2.6.28.
> 
> I also believe that a tunable for this is not going to be
> a very workable approach, for the simple reason that changing
> the value does not make a predictable change in the effectiveness
> of working set detection or protection.
> 
>> In my opinion, kernel just should do best effort to keep active working
>> set except some critical pages which are code pages.
> 
> Johannes has some experimental code to measure refaults, and
> calculate their distance in a multi-zone, multi-cgroup environment.
> 
> That would allow us to predictably place things in the working set
> as required.
> 


Hannes, it can help many people if you post your code. ;)


-- 
Kind regards,
Minchan Kim
