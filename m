Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0IGFc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 01:32:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39561 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab0IGFcW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 01:32:22 -0400
Date: Tue, 07 Sep 2010 07:31:30 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [RFCv5 3/9] mm: cma: Added SysFS support
In-reply-to: <20100906210747.GA5863@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Peter Zijlstra <peterz@infradead.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Pawel Osciak <p.osciak@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <op.vindmsj07p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1283749231.git.mina86@mina86.com>
 <9771a9c07874a642bb587f4c0ebf886d720332b6.1283749231.git.mina86@mina86.com>
 <20100906210747.GA5863@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

Thanks for reviewing the sysfs part.  Actually, I was never really sure
if I shouldn't rather put this code to debugfs and you got me convinced
that I should.  Sysfs somehow looked more appealing from kernel's API
point of view -- things seem to be more organised in sysfs than in
debugfs.  It seems I'll have to port it to debugfs after all

Nonetheless, a few responses to your comments:

> On Mon, Sep 06, 2010 at 08:33:53AM +0200, Michal Nazarewicz wrote:
>> +		The "allocators" file list all registered allocators.
>> +		Allocators with no name are listed as a single minus
>> +		sign.

On Mon, 06 Sep 2010 23:07:47 +0200, Greg KH <greg@kroah.com> wrote:
> So this returns more than one value?

Aren't thing like cpufreq governors listed in a single sysfs file?
I remember there was such a file somewhere.  Has that been made
deprecated? I cannot seem to find any information on that.

>> +		The "regions" directory list all reserved regions.
>
> Same here?

regions is actually a directory with subdirectories for each
region. ;)

>> +static ssize_t cma_sysfs_region_name_show(struct cma_region *reg, char *page)
>> +{
>> +	return reg->name ? snprintf(page, PAGE_SIZE, "%s\n", reg->name) : 0;
>> +}

> Is a name field ever really going to be bigger than a page?

I prefer being on the safe side -- I have no idea what user will provide
as region name so I assume as little as possible.  For numeric values you
are right that snprintf() is a bit paranoid, still I see no good reason
why not to use it.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

