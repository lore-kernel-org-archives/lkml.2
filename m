Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab1DLKcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 06:32:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57189 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214Ab1DLKcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 06:32:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NQudmIvh2GlwF0kgZRbxR0E5rX8bVmyFyukcB9Mu3XhxDZ/O0JvBKTqgNfLiyE/zJz
         AQ8bB3FowQmFhaVP6mqdZL2NzdkfvoLNgiqOllCo9ixgoX1UFasGIJW/SKx6EcrHREoh
         mk38AeUimoqFKx5UNZhE5+pHQ4b/Z3vVAFmW0=
MIME-Version: 1.0
In-Reply-To: <20110412192751.B52B.A69D9226@jp.fujitsu.com>
References: <20110411170033.0356.A69D9226@jp.fujitsu.com>
	<BANLkTimPB5e_A3AxS_7kuJmqciRciCm2Sw@mail.gmail.com>
	<20110412192751.B52B.A69D9226@jp.fujitsu.com>
Date: Tue, 12 Apr 2011 19:32:49 +0900
Message-ID: <BANLkTimkOn6f7tntEe2Agi5Mqk5OTfMp8A@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm, mem-hotplug: fix section mismatch.
 setup_per_zone_inactive_ratio() should be __meminit.
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasunori Goto <y-goto@jp.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 7:28 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>> On Mon, Apr 11, 2011 at 5:00 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Commit bce7394a3e (page-allocator: reset wmark_min and inactive ratio of
>> > zone when hotplug happens) introduced invalid section references.
>> > Now, setup_per_zone_inactive_ratio() is marked __init and then it can't
>> > be referenced from memory hotplug code.
>> >
>> > Then, this patch marks it as __meminit and also marks caller as __ref.
>> >
>> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>>
>> Just a nitpick.
>>
>> As below comment of __ref said, It would be better to add _why_ such
>> as memory_hotplug.c.
>>
>> "so optimally document why the __ref is needed and why it's OK"
>
> Hmm...
> All of memory_hotplug.c function can call __meminit function. It's
> definition of __meminit.
>
> We can put the same comment to every function in memory_hotplug.c.
> like hotadd_newpgdat().
>
> /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
> static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
> {
> (snip)
> }
>
> But it has zero information. ;)

It does make sense. Never mind. :)



-- 
Kind regards,
Minchan Kim
