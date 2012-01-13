Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab2AMVSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:18:20 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33218 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab2AMVST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:18:19 -0500
Message-ID: <4F109E50.5010104@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 15:12:48 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nitin Gupta <ngupta@vflare.org>,
        Matthew Wilcox <matthew@wil.cx>, Chris Mason <chris.mason@oracle.com>,
        Rik Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] mm: cleancache: s/flush/invalidate/
References: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com> <1326400580-16853-2-git-send-email-konrad.wilk@oracle.com> <4F104AD1.2080607@linux.vnet.ibm.com> <20120113174306.GB16182@phenom.dumpdata.com>
In-Reply-To: <20120113174306.GB16182@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011321-1976-0000-0000-0000097A8659
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 11:43 AM, Konrad Rzeszutek Wilk wrote:
> On Fri, Jan 13, 2012 at 09:16:33AM -0600, Seth Jennings wrote:
>> Hey Konrad,
>>
>> On 01/12/2012 02:36 PM, Konrad Rzeszutek Wilk wrote:
>>> From: Dan Magenheimer <dan.magenheimer@oracle.com>
>>>
>>> Per akpm suggestions alter the use of the term flush to be
>>> invalidate. The next patch will do this across all MM.
>>>
>>> This change is completely cosmetic.
>>>
>>> [v9: akpm@linux-foundation.org: change "flush" to "invalidate", part 3]
>>>
>>> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
>>> Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
>>> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>> Cc: Jan Beulich <JBeulich@novell.com>
>>> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
>>> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>>> Cc: Hugh Dickins <hughd@google.com>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>> Cc: Nitin Gupta <ngupta@vflare.org>
>>> Cc: Matthew Wilcox <matthew@wil.cx>
>>> Cc: Chris Mason <chris.mason@oracle.com>
>>> Cc: Rik Riel <riel@redhat.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> [v10: Fixed  fs: move code out of buffer.c conflict change]
>>> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>>> ---
>>>  Documentation/vm/cleancache.txt |   37 +++++++++++++++++++------------------
>>>  fs/block_dev.c                  |    2 +-
>>>  fs/super.c                      |    2 +-
>>>  include/linux/cleancache.h      |   23 ++++++++++++++---------
>>>  mm/cleancache.c                 |   19 ++++++++++---------
>>>  mm/filemap.c                    |    2 +-
>>>  mm/truncate.c                   |   10 +++++-----
>>>  7 files changed, 51 insertions(+), 44 deletions(-)
>> snip
>>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>>> index 69a5b6f..d6d5f29 100644
>>> --- a/fs/block_dev.c
>>> +++ b/fs/block_dev.c
>>> @@ -110,7 +110,7 @@ void invalidate_bdev(struct block_device *bdev)
>>>  	/* 99% of the time, we don't need to flush the cleancache on the bdev.
>>>  	 * But, for the strange corners, lets be cautious
>>>  	 */
>>> -	cleancache_flush_inode(mapping);
>>> +	cleancache_invalidate_inode(mapping);
>>>  }
>>>  EXPORT_SYMBOL(invalidate_bdev);
>>
>> This hunk doesn't merge cleanly because there is no existing
>> cleancache code in fs/block_dev.c in v3.2 or any previous version.
> 
> Hm, I am at 099469502f62fbe0d7e4f0b83a2f22538367f734 and I see
> that file with "cleancache_flush_inode" ?
> 
> This is against v3.3-rc0, not 3.2.

Ah yes.  Since no v3.3-rcX release has been tagged yet, I didn't
think to apply it there.

checkpatch clean, applies clean, builds clean

Consider all the patches in this set

Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

--
Seth

