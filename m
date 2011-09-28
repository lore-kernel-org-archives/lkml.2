Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab1I1A6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 20:58:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58622 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1I1A6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 20:58:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E8271C5.3080500@jp.fujitsu.com>
Date: Wed, 28 Sep 2011 10:00:53 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: jweiner@redhat.com
CC: consul.kautuk@gmail.com, akpm@linux-foundation.org, mel@csn.ul.ie,
        minchan.kim@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        lee.schermerhorn@hp.com
Subject: Re: [patch] mm: remove sysctl to manually rescue unevictable pages
References: <1316948380-1879-1-git-send-email-consul.kautuk@gmail.com> <20110926112944.GC14333@redhat.com>
In-Reply-To: <20110926112944.GC14333@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/09/26 20:29), Johannes Weiner wrote:
> On Sun, Sep 25, 2011 at 04:29:40PM +0530, Kautuk Consul wrote:
>> write_scan_unavictable_node checks the value req returned by
>> strict_strtoul and returns 1 if req is 0.
>>
>> However, when strict_strtoul returns 0, it means successful conversion
>> of buf to unsigned long.
>>
>> Due to this, the function was not proceeding to scan the zones for
>> unevictable pages even though we write a valid value to the 
>> scan_unevictable_pages sys file.
> 
> Given that there is not a real reason for this knob (anymore) and that
> it apparently never really worked since the day it was introduced, how
> about we just drop all that code instead?
> 
> 	Hannes
> 
> ---
> From: Johannes Weiner <jweiner@redhat.com>
> Subject: mm: remove sysctl to manually rescue unevictable pages
> 
> At one point, anonymous pages were supposed to go on the unevictable
> list when no swap space was configured, and the idea was to manually
> rescue those pages after adding swap and making them evictable again.
> But nowadays, swap-backed pages on the anon LRU list are not scanned
> without available swap space anyway, so there is no point in moving
> them to a separate list anymore.
> 
> The manual rescue could also be used in case pages were stranded on
> the unevictable list due to race conditions.  But the code has been
> around for a while now and newly discovered bugs should be properly
> reported and dealt with instead of relying on such a manual fixup.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>

About three years ago when we introduced unevictable pages feature,
we were worry about there are mlock, shmmem-lock abuse in the real
world and we broke such assumption. And we expected this knob help
to dig unevictable pages bug report. Briefly says, If this knob works
meangfully, our unevictable handling code or their driver code are buggy.

Fortunately, Such bug report was never happen. So, this knob finished
the role.

    Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




