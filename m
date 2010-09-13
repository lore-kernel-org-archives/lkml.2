Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0IMWSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 18:18:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13433 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab0IMWSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 18:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o2rTrijr2fHOI52Q5VTGhnD+hTuGmrfiVdRQX5FNmQlY7sJEWNRQ0lOVREuHXVO0vp
         LtBd8iH4voQGvycS8GXg==
MIME-Version: 1.0
In-Reply-To: <20100913142017.2a426365.akpm@linux-foundation.org>
References: <1284357493-20078-1-git-send-email-mrubin@google.com>
 <1284357493-20078-4-git-send-email-mrubin@google.com> <20100913142017.2a426365.akpm@linux-foundation.org>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 13 Sep 2010 15:17:36 -0700
Message-ID: <AANLkTinBs-fK4=fr+pc7aK0X+SBgkXDCB9n1aXsg=jyD@mail.gmail.com>
Subject: Re: [PATCH 3/5] writeback: nr_dirtied and nr_written in /proc/vmstat
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, fengguang.wu@intel.com, jack@suse.cz,
        riel@redhat.com, david@fromorbit.com, kosaki.motohiro@jp.fujitsu.com,
        npiggin@kernel.dk, hch@lst.de, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 2:20 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 12 Sep 2010 22:58:11 -0700
> Michael Rubin <mrubin@google.com> wrote:
>
>> To help developers and applications gain visibility into writeback
>> behaviour adding two entries to vm_stat_items and /proc/vmstat. This
>> will allow us to track the "written" and "dirtied" counts.
>>
>>    # grep nr_dirtied /proc/vmstat
>>    nr_dirtied 3747
>>    # grep nr_written /proc/vmstat
>>    nr_written 3618
>>
>> Signed-off-by: Michael Rubin <mrubin@google.com>
>> Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
>> ---
>>  include/linux/mmzone.h |    2 ++
>>  mm/page-writeback.c    |    2 ++
>>  mm/vmstat.c            |    3 +++
>>  3 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 6e6e626..d0d7454 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -104,6 +104,8 @@ enum zone_stat_item {
>>       NR_ISOLATED_ANON,       /* Temporary isolated pages from anon lru */
>>       NR_ISOLATED_FILE,       /* Temporary isolated pages from file lru */
>>       NR_SHMEM,               /* shmem pages (included tmpfs/GEM pages) */
>> +     NR_FILE_DIRTIED,        /* accumulated dirty pages */
>> +     NR_WRITTEN,             /* accumulated written pages */
>
> I think we can make those comments less ambiguous>
>
> --- a/include/linux/mmzone.h
> +++ a/include/linux/mmzone.h
> @@ -104,8 +104,8 @@ enum zone_stat_item {
>        NR_ISOLATED_ANON,       /* Temporary isolated pages from anon lru */
>        NR_ISOLATED_FILE,       /* Temporary isolated pages from file lru */
>        NR_SHMEM,               /* shmem pages (included tmpfs/GEM pages) */
> -       NR_FILE_DIRTIED,        /* accumulated dirty pages */
> -       NR_WRITTEN,             /* accumulated written pages */
> +       NR_FILE_DIRTIED,        /* page dirtyings since bootup */
> +       NR_WRITTEN,             /* page writings since bootup */

Got it. Will fix.

> The mismatch between "NR_FILE_DIRTIED" and "nr_dirtied" is a bit, umm,
> dirty.  I can kinda see the logic in the naming but still..

Got it will fix.

mrubin
