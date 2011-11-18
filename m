Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab1KRKHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:07:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41692 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab1KRKHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:07:06 -0500
Message-ID: <4EC62E46.6080503@openvz.org>
Date: Fri, 18 Nov 2011 14:07:02 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111010 Iceape/2.0.14
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: remove struct reclaim_state
References: <20111118092806.21688.8662.stgit@zurg> <20111118095644.GJ7046@dastard>
In-Reply-To: <20111118095644.GJ7046@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Fri, Nov 18, 2011 at 01:28:06PM +0300, Konstantin Khlebnikov wrote:
>> Memory reclaimer want to know how much pages was reclaimed during shrinking slabs.
>> Currently there is special struct reclaim_state with single counter and pointer from
>> task-struct. Let's store counter direcly on task struct and account freed pages
>> unconditionally. This will reduce stack usage and simplify code in reclaimer and slab.
>>
>> Logic in do_try_to_free_pages() is slightly changed, but this is ok.
>> Nobody calls shrink_slab() explicitly before do_try_to_free_pages(),
>
> Except for drop_slab() and shake_page()....

Indeed, but they do not care about accounting reclaimed pages and
they do not call do_try_to_free_pages() after all.

>
> Cheers,
>
> Dave.

