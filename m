Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0LQPmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:42:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43242 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab0LQPmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:42:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bDc1KbMOVeE48Vesd1yQHM0e5BGQBCG0npx1X07xsQtozXKBBrd+Oi2PRxZwLtc5kc
         j1g0rfQ+t8+8iPlNLiBofbfdTTn6nuKSKQrZlfplWUzaL7QL20E2Y7cn8+scueq0Y7Cf
         YUyHQdXEtRLFL1rOsIlN7SzwXJd44HGSHziSM=
MIME-Version: 1.0
In-Reply-To: <AANLkTima=Tqkga6RzWepLt_H6ooqZappcqZB4MKk546J@mail.gmail.com>
References: <20101213144646.341970461@intel.com>
	<20101213150329.002158963@intel.com>
	<20101217021934.GA9525@localhost>
	<alpine.LSU.2.00.1012162239270.23229@sister.anvils>
	<20101217112111.GA8323@localhost>
	<AANLkTima=Tqkga6RzWepLt_H6ooqZappcqZB4MKk546J@mail.gmail.com>
Date: Sat, 18 Dec 2010 00:42:18 +0900
Message-ID: <AANLkTimW4beh2Ta2TutKUeZ2fsER23r6E-MgW11ed6wK@mail.gmail.com>
Subject: Re: [PATCH] writeback: skip balance_dirty_pages() for in-memory fs
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 12:34 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Fri, Dec 17, 2010 at 8:21 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> This avoids unnecessary checks and dirty throttling on tmpfs/ramfs.
>>
>> It also prevents
>>
>> [  388.126563] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
>>
>> in the balance_dirty_pages tracepoint, which will call
>>
>>        dev_name(mapping->backing_dev_info->dev)
>>
>> but shmem_backing_dev_info.dev is NULL.
>>
>> CC: Hugh Dickins <hughd@google.com>
>> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>
> Is it a material for -stable?

No. balance_dirty_pages tracepoint is new. :)

>
> --
> Kind regards,
> Minchan Kim
>



-- 
Kind regards,
Minchan Kim
