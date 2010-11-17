Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0KQKQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:16:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41898 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0KQKQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:16:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IqFxp98qpWO0gvb1xkU+FQQW15aBqRlfB66PSLrob6201IaY6InPWRexoBuBkyavzC
         rlGghBLsoyiDarIkAdbRUqE3HPDvAGnaHdjf8kfkZo0CL8hh4mcqWwryo+hrRMaBAipK
         P2fk7E9mwQU1ztLHZtpVH06qu60zxi7X12fX4=
MIME-Version: 1.0
In-Reply-To: <4CE14848.2060805@redhat.com>
References: <20101109162525.BC87.A69D9226@jp.fujitsu.com>
	<877hgmr72o.fsf@gmail.com>
	<20101114140920.E013.A69D9226@jp.fujitsu.com>
	<AANLkTim59Qx6TsvXnTBL5Lg6JorbGaqx3KsdBDWO04X9@mail.gmail.com>
	<1289810825.2109.469.camel@laptop>
	<AANLkTikibS1fDuk67RHk4SU14pJ9nPdodWba1T3Z_pWE@mail.gmail.com>
	<4CE14848.2060805@redhat.com>
Date: Wed, 17 Nov 2010 19:16:19 +0900
Message-ID: <AANLkTi=6RtPDnZZa=jrcciB1zHQMiB3LnouBw3G2OyaK@mail.gmail.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ben Gamari <bgamari.foss@gmail.com>, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:48 PM, Rik van Riel <riel@redhat.com> wrote:
> On 11/15/2010 04:05 AM, Minchan Kim wrote:
>>
>> On Mon, Nov 15, 2010 at 5:47 PM, Peter Zijlstra<peterz@infradead.org>
>>  wrote:
>>>
>>> On Mon, 2010-11-15 at 15:07 +0900, Minchan Kim wrote:
>
>>>> I wonder what's the problem in Peter's patch 'drop behind'.
>>>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg179576.html
>>>>
>>>> Could anyone tell me why it can't accept upstream?
>>>
>>> Read the thread, its quite clear nobody got convinced it was a good idea
>>> and wanted to fix the use-once policy, then Rik rewrote all of
>>> page-reclaim.
>>>
>>
>> Thanks for the information.
>> I hope this is a chance to rethink about it.
>> Rik, Could you give us to any comment about this idea?


Sorry for late reply, Rik.

> At the time, there were all kinds of general problems
> in page reclaim that all needed to be fixed.  Peter's
> patch was mostly a band-aid for streaming IO.
>
> However, now that most of the other page reclaim problems
> seem to have been resolved, it would be worthwhile to test
> whether Peter's drop-behind approach gives an additional
> improvement.

Okay. I will have a time to make the workload for testing.

>
> I could see it help by getting rid of already-read pages
> earlier, leaving more space for read-ahead data.

Yes. Peter's logic breaks demotion if the page is in active list.
But I think if it's just active page like rsync's two touch, we have
to move tail of inactive although it's in active list.
I will look into this, too.

>
> I suspect it would do fairly little to protect the working
> set, because we do not scan the active file list at all
> unless it grows to be larger than the inactive file list.

Absolutely. But how about rsync's two touch?
It can evict working set.

I need the time for investigation.
Thanks for the comment.


>
> --
> All rights reversed
>



-- 
Kind regards,
Minchan Kim
