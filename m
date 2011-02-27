Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1B0Xiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:38:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33849 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1B0Xiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:38:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e/mqiu+bBugcyfjYQ+P/J13avCNoCBvsp0FTJmIxroB8LSljrnCysY1eBVxSJF3Q+4
         KYr1nv5Gm+ZPZzQP+tuM3ZDUY/8cNKLYMtKa81saMwTB4aOyxfj07WYZ7TNqsHhR5Ewz
         4gYbJ7ZsBgdJXfffQittufTyywdZi9jTKR2ZM=
MIME-Version: 1.0
In-Reply-To: <20110227210951.GZ25382@cmpxchg.org>
References: <1298821765-3167-1-git-send-email-minchan.kim@gmail.com>
	<20110227210951.GZ25382@cmpxchg.org>
Date: Mon, 28 Feb 2011 08:38:50 +0900
Message-ID: <AANLkTin6ypqWf7xCufFru1rB_MBptk5o9RSxPC-S9_a3@mail.gmail.com>
Subject: Re: [PATCH] memcg: clean up migration
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 6:09 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Mon, Feb 28, 2011 at 12:49:25AM +0900, Minchan Kim wrote:
>> This patch cleans up unncessary BUG_ON check and confusing
>> charge variable.
>>
>> That's because memcg charge/uncharge could be handled by
>> mem_cgroup_[prepare/end] migration itself so charge local variable
>> in unmap_and_move lost the role since we introduced 01b1ae63c2.
>>
>> And mem_cgroup_prepare_migratio return 0 if only it is successful.
>> Otherwise, it jumps to unlock label to clean up so BUG_ON(charge)
>> isn;t meaningless.
>>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
>> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
>
> Thanks, Minchan!
>
>        Hannes
>
> PS: Btw, people sometimes refer to commits by hashes from trees other
> than Linus's, so it's nice to include the subject as well:
>
>        01b1ae6 memcg: simple migration handling
>
> You get this easily by taking the first line of
>
>        git show --oneline <commithash>
>
> though there are probably other ways.
>

I forgot adding the name with old comment's copy & paste. I will
resend with fixing some typo.

Thanks.


-- 
Kind regards,
Minchan Kim
