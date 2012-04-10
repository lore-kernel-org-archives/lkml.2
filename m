Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab2DJAtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab2DJAtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:49:31 -0400
Message-ID: <4F838390.1080909@redhat.com>
Date: Mon, 09 Apr 2012 20:49:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Alexey Ivanov <rbtz@yandex-team.ru>,
        "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, yinghan@google.com
Subject: Re: mapped pagecache pages vs unmapped pages
References: <37371333672160@webcorp7.yandex-team.ru> <4F7E9854.1020904@gmail.com> <12701333991475@webcorp7.yandex-team.ru> <4F8326FD.8020507@redhat.com> <8041334015453@webcorp4.yandex-team.ru> <4F837F6E.3010508@kernel.org>
In-Reply-To: <4F837F6E.3010508@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 08:31 PM, Minchan Kim wrote:
> 2012-04-10 오전 8:50, Alexey Ivanov 쓴 글:
>
>> Did you consider making this ratio tunable, at least manually(i.e. via sysctl)?
>> I suppose we are not the only ones with almost-whole-ram-mmaped workload.
>
> Personally, I think it's not good approach.
> It depends on kernel's internal implemenatation which would be changed
> in future as we chagend it at 2.6.28.

I also believe that a tunable for this is not going to be
a very workable approach, for the simple reason that changing
the value does not make a predictable change in the effectiveness
of working set detection or protection.

> In my opinion, kernel just should do best effort to keep active working
> set except some critical pages which are code pages.

Johannes has some experimental code to measure refaults, and
calculate their distance in a multi-zone, multi-cgroup environment.

That would allow us to predictably place things in the working set
as required.

-- 
All rights reversed
