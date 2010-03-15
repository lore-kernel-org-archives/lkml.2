Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936298Ab0CONs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:48:29 -0400
Received: from mail-px0-f181.google.com ([209.85.216.181]:55740 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935389Ab0CONs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iZp+7xx9+ptSo/zf94Ho4AP0SR+HiKlTxYrzXjTQNCAkz829Xfg41+NTyjNZ6Fii6c
         v2FqiZc5HGqI9bvQwM19txxnftkTmV6GH2Px0DUimiBowGnUbRle0Uw6UcuMGKIDhYVT
         aHABN/jSpJ8Qt/J63J3ZLOnsFtmoW0u6UCWBA=
MIME-Version: 1.0
In-Reply-To: <20100315160919.c46fcc5a.kamezawa.hiroyu@jp.fujitsu.com>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie>
	 <1268412087-13536-3-git-send-email-mel@csn.ul.ie>
	 <28c262361003141728g4aa40901hb040144c5a4aeeed@mail.gmail.com>
	 <20100315143420.6ec3bdf9.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262361003142328w610f0478sbc17880ffa454fe8@mail.gmail.com>
	 <20100315154459.c665f68d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100315160919.c46fcc5a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 15 Mar 2010 22:48:25 +0900
Message-ID: <28c262361003150648v59baf43cx829248c33b4ce607@mail.gmail.com>
Subject: Re: [PATCH 02/11] mm,migration: Do not try to migrate unmapped 
	anonymous pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 4:09 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 15 Mar 2010 15:44:59 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> On Mon, 15 Mar 2010 15:28:15 +0900
>> Minchan Kim <minchan.kim@gmail.com> wrote:
>>
>> > On Mon, Mar 15, 2010 at 2:34 PM, KAMEZAWA Hiroyuki
>> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > > On Mon, 15 Mar 2010 09:28:08 +0900
>> > > Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> > I think above scenario make error "use-after-free", again.
>> > What prevent above scenario?
>> >
>> I think this patch is not complete.
>> I guess this patch in [1/11] is trigger for the race.
>> ==
>> +
>> +     /* Drop an anon_vma reference if we took one */
>> +     if (anon_vma && atomic_dec_and_lock(&anon_vma->migrate_refcount, &anon_vma->lock)) {
>> +             int empty = list_empty(&anon_vma->head);
>> +             spin_unlock(&anon_vma->lock);
>> +             if (empty)
>> +                     anon_vma_free(anon_vma);
>> +     }
>> ==
>> If my understainding in above is correct, this "modify" freed anon_vma.
>> Then, use-after-free happens. (In old implementation, there are no refcnt,
>> so, there is no use-after-free ops.)
>>
> Sorry, about above, my understanding was wrong. anon_vma->lock is modifed even
> in old code. Sorry for noise.

Nope.  Such your kindness always helps and cheer up others people.
In addition, give others good time to consider seriously something.

Thanks, Kame.


-- 
Kind regards,
Minchan Kim
