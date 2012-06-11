Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2FKO6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:58:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50411 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab2FKO6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:58:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1206110937430.31180@router.home>
References: <1339422650-9798-1-git-send-email-kosaki.motohiro@gmail.com>
 <alpine.DEB.2.00.1206110856180.31180@router.home> <4FD60127.1000805@jp.fujitsu.com>
 <alpine.DEB.2.00.1206110937430.31180@router.home>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 11 Jun 2012 10:58:27 -0400
X-Google-Sender-Auth: -aTIwLLO2RKQLEPCYf5EFUjjz98
Message-ID: <CAHGf_=rdcoC8wWzcAfDpqekFnmBSCtyEp2nFXV+DFBzgpHEF1A@mail.gmail.com>
Subject: Re: [PATCH] mm: fix protection column misplacing in /proc/zoneinfo
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:40 AM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 11 Jun 2012, KOSAKI Motohiro wrote:
>
>> On 6/11/2012 10:02 AM, Christoph Lameter wrote:
>> > On Mon, 11 Jun 2012, kosaki.motohiro@gmail.com wrote:
>> >
>> >> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> >>
>> >> commit 2244b95a7b (zoned vm counters: basic ZVC (zoned vm counter)
>> >> implementation) broke protection column. It is a part of "pages"
>> >> attribute. but not it is showed after vmstats column.
>> >>
>> >> This patch restores the right position.
>> >
>> > Well this reorders the output. vmstats are also counts of pages. I am not
>> > sure what the difference is.
>>
>> No. In this case, "pages" mean zone attribute. In the other hand, vmevent
>> is a statistics.
>
> The vmevent countes are something different from the zone counters. Event
> counters are indeed statistics only but the numbers here were intended
> to be are actual counts of pages. Well some of them like the numa_XXX are
> stats you are right. Those could be moved off the ZVCs and become event
> counters.
>
>> > You are not worried about breaking something that may scan the zoneinfo
>> > output with this change? Its been this way for 6 years and its likely that
>> > tools expect the current layout.
>>
>> I don't worry about this. Because of, /proc/zoneinfo is cray machine unfrinedly
>> format and afaik no application uses it.
>
> Cray? What does that have to do with it.

sorry. s/cray/crazy/


>
>> btw, I believe we should aim /sys/devices/system/node/<node-num>/zones new directory
>> and export zone infos as machine readable format.
>
> Yes that would be a good thing.
