Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab1CJQS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:18:59 -0500
Received: from smtp-out.google.com ([74.125.121.67]:53523 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1CJQS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:18:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QO5BXPYevNr2iXNZFY9hxFO36mpeobUVbu0vE8iv3nwNgXRGUNwzz24ZvhdHEeNIwH
         2VbIEVnvz9p2bAzcE0Sw==
MIME-Version: 1.0
In-Reply-To: <20110228114018.390ce291.kamezawa.hiroyu@jp.fujitsu.com>
References: <1298669760-26344-1-git-send-email-gthelen@google.com>
 <1298669760-26344-7-git-send-email-gthelen@google.com> <20110227170143.GE3226@barrios-desktop>
 <20110228114018.390ce291.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 10 Mar 2011 08:18:33 -0800
Message-ID: <AANLkTimuHeGMY0ELXgsn+BmAibvV34x3RvphF+3SODqw@mail.gmail.com>
Subject: Re: [PATCH v5 6/9] memcg: add kernel calls for memcg dirty page stats
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 6:40 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Mon, 28 Feb 2011 02:01:43 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Fri, Feb 25, 2011 at 01:35:57PM -0800, Greg Thelen wrote:
>                spin_unlock_irqrestore(&mapping->tree_lock, flags);
>> >     } else {
>> > @@ -1365,6 +1368,7 @@ int test_set_page_writeback(struct page *page)
>> >                                             PAGECACHE_TAG_WRITEBACK);
>> >                     if (bdi_cap_account_writeback(bdi))
>> >                             __inc_bdi_stat(bdi, BDI_WRITEBACK);
>> > +                   mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_WRITEBACK);
>>
>> Question:
>> Why should we care of BDI_CAP_NO_WRITEBACK?
>>
> Hmm, should we do ..
> ==
>        if (!ret) {
>                account_page_writeback(page);
> +               mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_WRITEBACL);
>        }
> ==

Yes, I agree with Minchan that this is an issue.  I think Kame's fix
is good.  I will apply Kame's fix to test_set_page_writeback().  I
also found that test_clear_page_writeback() has the same issue and it
will also be fixed.  I will be posting v6 shortly (hopefully today)
with these fixes.

> Thanks,
> -Kame
>
>
