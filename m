Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2FDAqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 20:46:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:56527 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab2FDAqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 20:46:16 -0400
Message-ID: <4FCC0553.80100@gmail.com>
Date: Sun, 03 Jun 2012 20:46:11 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
References: <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils> <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com> <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com> <alpine.LSU.2.00.1206012108430.11308@eggly.anvils> <20120603181548.GA306@redhat.com> <CA+55aFwZ5PsBLqM7K8vDQdbS3sf+vi3yeoWx6XKV=nF8k2r7DQ@mail.gmail.com> <20120603183139.GA1061@redhat.com> <20120603205332.GA5412@redhat.com> <alpine.LSU.2.00.1206031459450.15427@eggly.anvils> <CA+55aFz--XDSOConDoM2SO0Jpd78Dg4GsGP+Z0F+__JWz+6JoQ@mail.gmail.com>
In-Reply-To: <CA+55aFz--XDSOConDoM2SO0Jpd78Dg4GsGP+Z0F+__JWz+6JoQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/3/12 7:13 PM), Linus Torvalds wrote:
> On Sun, Jun 3, 2012 at 3:17 PM, Hugh Dickins<hughd@google.com>  wrote:
>>
>> But another strike against that commit: I tried fixing it up to use
>> start_page instead of page at the end, with the worrying but safer
>> locking I suggested at first, with a count of how many times it went
>> there, and how many times it succeeded.
>
> You can't use start_page anyway, it might not be a valid page. There's
> a reson it does that "pfn_valid_within()", methinks.

Right. ia64 has strange^H^H^H^H optimized pfn_valid and we need care it.
(btw, I don't understand why mips may enable CONFIG_HOLES_INZONE, mips doesn't
have custom pfn_valid)


> Anyway, my current plan is to apply your "mm: fix warning in
> __set_page_dirty_nobuffers" patch - even if it's just a harmless
> WARN_ON_ONCE(), and revert 5ceb9ce6fe94. Sounds like Dave hit normally
> hit his problem much before two hours, and it must be even longer now.
>
> Ack on that plan?

+1.
