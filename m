Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab0KOOs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:48:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756998Ab0KOOs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:48:57 -0500
Message-ID: <4CE14848.2060805@redhat.com>
Date: Mon, 15 Nov 2010 09:48:40 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Gamari <bgamari.foss@gmail.com>, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
References: <20101109162525.BC87.A69D9226@jp.fujitsu.com>	<877hgmr72o.fsf@gmail.com>	<20101114140920.E013.A69D9226@jp.fujitsu.com>	<AANLkTim59Qx6TsvXnTBL5Lg6JorbGaqx3KsdBDWO04X9@mail.gmail.com>	<1289810825.2109.469.camel@laptop> <AANLkTikibS1fDuk67RHk4SU14pJ9nPdodWba1T3Z_pWE@mail.gmail.com>
In-Reply-To: <AANLkTikibS1fDuk67RHk4SU14pJ9nPdodWba1T3Z_pWE@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 04:05 AM, Minchan Kim wrote:
> On Mon, Nov 15, 2010 at 5:47 PM, Peter Zijlstra<peterz@infradead.org>  wrote:
>> On Mon, 2010-11-15 at 15:07 +0900, Minchan Kim wrote:

>>> I wonder what's the problem in Peter's patch 'drop behind'.
>>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg179576.html
>>>
>>> Could anyone tell me why it can't accept upstream?
>>
>> Read the thread, its quite clear nobody got convinced it was a good idea
>> and wanted to fix the use-once policy, then Rik rewrote all of
>> page-reclaim.
>>
>
> Thanks for the information.
> I hope this is a chance to rethink about it.
> Rik, Could you give us to any comment about this idea?

At the time, there were all kinds of general problems
in page reclaim that all needed to be fixed.  Peter's
patch was mostly a band-aid for streaming IO.

However, now that most of the other page reclaim problems
seem to have been resolved, it would be worthwhile to test
whether Peter's drop-behind approach gives an additional
improvement.

I could see it help by getting rid of already-read pages
earlier, leaving more space for read-ahead data.

I suspect it would do fairly little to protect the working
set, because we do not scan the active file list at all
unless it grows to be larger than the inactive file list.

-- 
All rights reversed
