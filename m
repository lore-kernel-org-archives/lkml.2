Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab1HLEeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 00:34:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61410 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab1HLEeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 00:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzXJo78Ah_Qiy6cSHdXHv165nXJ2nTD186NNdCXBABZjA@mail.gmail.com>
References: <20110811064059.GU6342@yookeroo.fritz.box>
	<CA+55aFzXJo78Ah_Qiy6cSHdXHv165nXJ2nTD186NNdCXBABZjA@mail.gmail.com>
Date: Fri, 12 Aug 2011 13:34:17 +0900
Message-ID: <CAEwNFnB+5DZQw0CrfkcdP_rd5FBM6fw26=_yS3P283a9TKLNiw@mail.gmail.com>
Subject: Re: Fix refcounting in hugetlbfs quota handling
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@web.de>, qemu-devel@nongnu.org, agraf@suse.de,
        kvm <kvm@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrew Hastings <abh@cray.com>,
        Adam Litke <agl@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 9:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Aug 10, 2011 at 11:40 PM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
>>
>> This patch, therefore, stores a pointer to the inode instead of the
>> address_space in the page private data for hugepages.  More
>> importantly it correctly adjusts the reference count on the inodes
>> when they're added to the page private data.  This ensures that the
>> inode (and therefore the super block) will not be freed before we use
>> it from free_huge_page.
>
> Looks sane, but I *really* want some acks from people who use/know
> hugetlbfs. Who would that be? I'm adding random people who have
> acked/signed-off patches to hugetlbfs recently..

At least, code itself looks good to me but your random choice was failed.
Maybe people you want are as follows.
http://marc.info/?t=126928975800003&r=1&w=2

Ccing right persons.

-- 
Kind regards,
Minchan Kim
