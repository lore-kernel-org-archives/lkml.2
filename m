Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2FDBra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:47:30 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:57952 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab2FDBr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:47:29 -0400
Message-ID: <4FCC13AC.3070005@gmail.com>
Date: Sun, 03 Jun 2012 21:47:24 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com> <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils> <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com> <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com> <alpine.LSU.2.00.1206012108430.11308@eggly.anvils> <4FCC0B09.1070708@kernel.org> <alpine.LSU.2.00.1206031820520.5143@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1206031820520.5143@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -       set_pageblock_migratetype(page, MIGRATE_MOVABLE);
>> -       move_freepages_block(page_zone(page), page, MIGRATE_MOVABLE);
>> +       set_pageblock_migratetype(start_page, MIGRATE_MOVABLE);
>> +       move_freepages_block(page_zone(start_page), start_page, MIGRATE_MOVABLE);
>
> No.  I guess we can assume the incoming page was valid (fair?),
> so should still use that, but something else for the loop iterator.

Fair. passed page is always valid.

