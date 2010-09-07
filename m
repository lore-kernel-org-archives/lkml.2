Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab0IGG4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 02:56:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40777 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0IGG4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 02:56:03 -0400
Date: Tue, 07 Sep 2010 08:55:12 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [RFCv5 3/9] mm: cma: Added SysFS support
In-reply-to: <20100907060818.GA2609@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: linux-arm-kernel@lists.infradead.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawel Osciak <p.osciak@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mel Gorman <mel@csn.ul.ie>, Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vinhiabu7p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1283749231.git.mina86@mina86.com>
 <9771a9c07874a642bb587f4c0ebf886d720332b6.1283749231.git.mina86@mina86.com>
 <20100906210747.GA5863@kroah.com> <op.vindmsj07p4s8u@localhost>
 <20100907060818.GA2609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Sep 07, 2010 at 07:31:30AM +0200, Micha?? Nazarewicz wrote:
>> Thanks for reviewing the sysfs part.  Actually, I was never really sure
>> if I shouldn't rather put this code to debugfs and you got me convinced
>> that I should.  Sysfs somehow looked more appealing from kernel's API
>> point of view -- things seem to be more organised in sysfs than in
>> debugfs.  It seems I'll have to port it to debugfs after all

On Tue, 07 Sep 2010 08:08:18 +0200, Greg KH <greg@kroah.com> wrote:
> Yes, debugfs looks like a much better place for this.

I'll fix that in v6 then.

>>>> +static ssize_t cma_sysfs_region_name_show(struct cma_region *reg, char *page)
>>>> +{
>>>> +	return reg->name ? snprintf(page, PAGE_SIZE, "%s\n", reg->name) : 0;
>>>> +}

>>> Is a name field ever really going to be bigger than a page?

>> For numeric values you are right that snprintf() is a bit paranoid,
>> still I see no good reason why not to use it.

> Same goes for no good reason to use it :)

I somehow prefer to always use "safe" versions of the string manipulation
functions -- it's better to use it everywhere then to forget it in one
place.  Call to sprintf() is translated to vsnprintf() anyway so there's
no performance gain.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

