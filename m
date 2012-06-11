Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2FKOb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:31:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38581 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2FKObz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:31:55 -0400
Message-ID: <4FD60127.1000805@jp.fujitsu.com>
Date: Mon, 11 Jun 2012 10:31:03 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: cl@linux.com
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH] mm: fix protection column misplacing in /proc/zoneinfo
References: <1339422650-9798-1-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1206110856180.31180@router.home>
In-Reply-To: <alpine.DEB.2.00.1206110856180.31180@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/2012 10:02 AM, Christoph Lameter wrote:
> On Mon, 11 Jun 2012, kosaki.motohiro@gmail.com wrote:
> 
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> commit 2244b95a7b (zoned vm counters: basic ZVC (zoned vm counter)
>> implementation) broke protection column. It is a part of "pages"
>> attribute. but not it is showed after vmstats column.
>>
>> This patch restores the right position.
> 
> Well this reorders the output. vmstats are also counts of pages. I am not
> sure what the difference is.

No. In this case, "pages" mean zone attribute. In the other hand, vmevent
is a statistics.


> You are not worried about breaking something that may scan the zoneinfo
> output with this change? Its been this way for 6 years and its likely that
> tools expect the current layout.

I don't worry about this. Because of, /proc/zoneinfo is cray machine unfrinedly
format and afaik no application uses it.

btw, I believe we should aim /sys/devices/system/node/<node-num>/zones new directory
and export zone infos as machine readable format.
